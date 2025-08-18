
# ---- Packages ----
# install.packages(c("tidyverse", "cluster", "janitor", "factoextra"))
library(tidyverse)
library(cluster)
library(janitor)
# factoextra is optional (for a nicer dendrogram);

# ---- Paths ----
# set your working directory to the project root
# setwd("your/path/to/project")

# CSV filename expected per README/project
csv_file <- "event_attendance.csv"

# ---- Load data (preserve spaces/punctuation in names) ----
event_df <- read.csv(csv_file, check.names = FALSE)

# Code-style target names on the left-hand side
name_map <- c(
  Inquiry                   = "Inquiry",
  Subscriber                = "Subscriber",
  Marketing_Initiative_Target = "Marketing Initiative Target",
  No_College_Degree         = "No College Degree",
  Low_Income                = "Income < $20,000",
  Underserved_Region        = "underserved Region",
  URM_Status                = "URM"
)

# Rename columns robustly using base R (handles spaces safely)
cols <- names(event_df)
for (i in seq_along(name_map)) {
  old <- unname(name_map[i])
  new <- names(name_map)[i]
  if (old %in% cols) cols[cols == old] <- new
}
names(event_df) <- cols

# ---- Validate required columns ----
needed <- names(name_map)
missing <- setdiff(needed, names(event_df))
if (length(missing) > 0) {
  stop(
    "Missing required columns: ",
    paste(missing, collapse = ", "),
    call. = FALSE
  )
}

# ---- Coerce to binary numeric (0/1) and handle NAs ----
# Accept common inputs: 1/0, "1"/"0", TRUE/FALSE, Yes/No, Y/N, T/F (any case)
cluster_vars <- event_df %>%
  transmute(
    across(
      all_of(needed),
      ~ case_when(
        . %in% c(1, "1", TRUE, "TRUE", "True", "true", "Yes", "YES", "yes", "Y", "y", "T", "t") ~ 1,
        . %in% c(0, "0", FALSE, "FALSE", "False", "false", "No", "NO", "no", "N", "n", "F", "f") ~ 0,
        TRUE ~ NA_real_
      ),
      .names = "{.col}"
    )
  )

# Drop rows with any NA in the clustering variables
cluster_vars <- cluster_vars %>% drop_na()

# ---- Distance (Manhattan) & Hierarchical clustering (average linkage) ----
dist_matrix <- dist(cluster_vars, method = "manhattan")
hc_avg <- hclust(dist_matrix, method = "average")

#  dendrogram 
if (requireNamespace("factoextra", quietly = TRUE)) {
  factoextra::fviz_dend(hc_avg, main = "Dendrogram of Event Attendees", k = 5, show_labels = FALSE)
}

# ---- Cut tree into k clusters ----
k <- 5
cluster_assignments <- cutree(hc_avg, k = k)

# ---- Bind cluster IDs to data used for clustering ----
event_clustered <- bind_cols(cluster_vars, clusterID = cluster_assignments)

# ---- Cluster sizes ----
cluster_counts <- event_clustered %>%
  count(clusterID, name = "Count") %>%
  arrange(clusterID)
print(cluster_counts)

# ---- Per-cluster variable profiles (percent 'Yes' = 1) ----
profile_long <- event_clustered %>%
  pivot_longer(-clusterID, names_to = "variable", values_to = "value") %>%
  group_by(clusterID, variable) %>%
  summarize(
    pct_yes = mean(value == 1, na.rm = TRUE),
    n = n(),
    .groups = "drop"
  ) %>%
  mutate(pct_label = scales::percent(pct_yes, accuracy = 1))

# Long (tidy) profile table
profile_long %>% arrange(variable, clusterID) %>% print(n = Inf)

# Wide profile table (one row per cluster, columns are variables, values are % yes)
profile_wide <- profile_long %>%
  select(clusterID, variable, pct_yes) %>%
  pivot_wider(names_from = variable, values_from = pct_yes) %>%
  arrange(clusterID)

# Format as percentages for display
profile_wide_pretty <- profile_wide %>%
  mutate(across(-clusterID, ~ scales::percent(., accuracy = 1)))

print(profile_wide_pretty)

# Example janitor cross-tab
# e.g., No_College_Degree by cluster with % and Ns
tabyl(event_clustered, No_College_Degree, clusterID) %>%
  adorn_percentages("col") %>%
  adorn_pct_formatting(digits = 1) %>%
  adorn_ns() %>%
  print()

# example: Underserved_Region by cluster
tabyl(event_clustered, Underserved_Region, clusterID) %>%
  adorn_percentages("col") %>%
  adorn_pct_formatting(digits = 1) %>%
  adorn_ns() %>%
  print()


