# 📊 Hierarchical Clustering: Event Attendance Analysis

This project uses hierarchical clustering in R to analyze patterns among attendees of admissions events (tours, open houses, accepted student days). The analysis helps identify traits that correlate with event attendance and informs targeted recruitment strategies.

---

## 🎯 Objective

Group event attendees by shared traits to better personalize outreach and increase event attendance.

---

## 🗂️ Dataset Overview

- **Source**: Query
- **Timeframe**: 2021–2024
- **Population**: 235 event attendees  
- **Events**: Campus Tours, Accepted Student Days, Open Houses  
- **Variables Used (Binary Format)**:
  - Applicant
  - Inquiry
  - Campaigns 
  - First Generation
  - Income/Economically Disadvantaged
  - Health Professional Shortage Area
  - URIM

---

## 🧪 Methodology

- **Software**: RStudio  
- **Clustering Method**: Agglomerative Hierarchical Clustering  
- **Distance Metric**: Manhattan  
- **Linkage**: Group Average Linkage  
- **Output**: Dendrogram visualization, 5 clusters identified

---

## 📌 Key Clusters Identified

### Cluster 1: Economically Disadvantaged First-Gen Applicants
- High first-gen and economically disadvantaged representation  
- 61% from medically underserved areas  

### Cluster 2: Diverse Applicants with Moderate Economic Status  
- 34% URIM  
- No first-gen students  

### Cluster 3: High Targeted Marketing Engagement  
- 100% involved in a marketing initiative  
- All URIM, all economically disadvantaged  

### Cluster 4: Underserved Applicants  
- 100% from medically underserved areas  

### Cluster 5: General Inquiries with URIM Representation  
- 31% URIM  
- All non-applicants

---

## 💡 Strategic Recommendations

1. **Expand Targeted Marketing**  
   Boost outreach for Clusters 1, 3, and 4

2. **Offer Financial Incentives**  
   Promote scholarships, waivers, or travel assistance

3. **Support First-Gen Students**  
   Tailored materials, mentoring, and premed resources

4. **Emphasize Diversity**  
   Feature URIM speakers and student panels

5. **Geographic Targeting**  
   Focus outreach in medically underserved communities

---

## 📂 Files Included

- `README.md` — This documentation

---

## 👩‍💼 Author

**Dana Brooks**  
📧 [danatallent@yahoo.com](mailto:danatallent@yahoo.com)  
🔗 [LinkedIn](https://linkedin.com/in/dana-tallent-brooks-a15977a0)

---

> “When you understand your audience, you don’t have to work as hard to reach them.”
