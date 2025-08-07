# Load libraries
library(tidyverse)
library(cluster)
library(factoextra)
library(janitor)

# Set working directory
setwd("your/path/to/project")

# Load dataset
event_df <- read.csv("event_attendance.csv")

# Select binary clustering variables
cluster_vars <- event_df %>%
  select(Inquiry, Subscriber, Marketing_Initiative_Target,
         No_College_Degree, Low_Income, Underserved_Region, URM_Status)

# Calculate Manhattan distance
dist_matrix <- dist(cluster_vars, method = "manhattan")

# Perform hierarchical clustering using average linkage
hc_avg <- hclust(dist_matrix, method = "average")

# Plot dendrogram
plot(hc_avg, main = "Dendrogram of Event Attendees", xlab = "", sub = "")

# Cut tree into 5 clusters
cluster_assignments <- cutree(hc_avg, k = 5)

# Bind cluster IDs to data
event_clustered <- bind_cols(cluster_vars, clusterID = cluster_assignments)

# Frequency counts by cluster
event_clustered %>%
  group_by(clusterID) %>%
  summarize(Count = n())

# Attach factor labels for readability (optional)
event_clustered <- event_clustered %>%
  mutate(
    Inquiry = factor(Inquiry, labels = c("No", "Yes")),
    Subscriber = factor(Subscriber, labels = c("No", "Yes")),
    Marketing_Initiative_Target = factor(Marketing_Initiative_Target, labels = c("No", "Yes")),
    No_College_Degree = factor(No_College_Degree, labels = c("No", "Yes")),
    Low_Income = factor(Low_Income, labels = c("No", "Yes")),
    Underserved_Region = factor(Underserved_Region, labels = c("No", "Yes")),
    URM_Status = factor(URM_Status, labels = c("No", "Yes"))
  )

# Example cluster breakdown table
tabyl(event_clustered, No_College_Degree, clusterID) %>%
  adorn_percentages("col") %>%
  adorn_pct_formatting(digits = 1) %>%
  adorn_ns()
