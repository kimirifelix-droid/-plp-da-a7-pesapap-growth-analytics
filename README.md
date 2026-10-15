# PesaPap Growth Analytics

## 1. Project Summary

PesaPap Growth Analytics is a fictional Kenyan digital-payments analysis project developed using SQL and Python. It examines transaction performance, customer value, retention patterns and an onboarding A/B experiment.

The goal is to demonstrate practical junior data analyst skills and provide evidence-based recommendations for a fintech growth team.

## 2. Business Questions

- Which products generate the highest transaction value and volume?
- Which counties and acquisition channels contribute the most transaction value?
- How does transaction value change over time?
- Who are the highest-value customers?
- How can customers be segmented by lifetime transaction value?
- What do cohort retention patterns reveal?
- Does the simplified onboarding experience improve conversion?

## 3. Dataset and Database

The project uses three synthetic CSV datasets generated with seed 77.

| Dataset | Rows | Purpose |
|---|---:|---|
| users.csv | 3,000 | User registration, county and acquisition channel |
| transactions.csv | 12,000 | Transaction dates, products and amounts |
| experiment.csv | 3,000 | Experiment group assignment and conversion outcome |

The analysis loads the data into SQLite database tables and uses SQL queries with joins, aggregations, CTEs, CASE expressions, ranking and window functions.

## 4. Tools and Skills

- Python and Jupyter Notebook
- Pandas and NumPy
- SQLite and SQL
- Data cleaning and validation
- KPI scorecards and metric definitions
- RFM-style customer segmentation
- Cohort retention analysis
- A/B testing, chi-square testing and confidence intervals
- Business reporting and recommendations

## 5. Key Findings and Insights

1. **Variant B had a higher conversion rate.** Group A converted at 10.46% (151 of 1,443 participants), compared with 13.81% (215 of 1,557) for Group B.

2. **The experiment showed statistically significant evidence of improvement.** The absolute conversion lift was 3.34 percentage points, relative lift was 31.96%, and the chi-square p-value was 0.005168. The 95% confidence interval for absolute lift was 1.01 to 5.67 percentage points.

3. **Transaction dates contain a material data-quality issue.** There were 3,737 transactions, representing 31.14% of all transactions, dated before the associated user's signup date. Lifecycle and retention conclusions therefore require caution.

4. **Customer segmentation can guide growth actions.** The analysis recommends investigating high-value customers first, using retention offers for at-risk high-value customers and loyalty benefits for active high-value customers.

5. **Cohort retention must be interpreted carefully.** Future or unobserved cohort periods are flagged as incomplete. These cells should not be interpreted as evidence of customer churn.

## 6. Experiment Recommendation

Recommend a monitored, staged rollout of variant B rather than an unconditional full rollout.

At an illustrative volume of 3,000 eligible sign-ups per month, the observed lift corresponds to approximately 100 additional conversions, with an approximate 95% interval of 30 to 170. This is a scenario estimate, not a guarantee.

Monitor conversion, onboarding completion, fraud, customer support contacts and subsequent transaction activity during rollout.

## 7. Project Structure

- `generate_data.py` — generates the synthetic datasets.
- `users.csv` — generated user dataset.
- `transactions.csv` — generated transaction dataset.
- `experiment.csv` — generated experiment dataset.
- `sql/queries.sql` — data validation and SQL questions A–H.
- `pesapap_analysis.ipynb` — executable analysis notebook with outputs.
- `reports/growth_memo.md` — business-facing growth memo.
- `requirements.txt` — Python dependencies.
- `.gitignore` — excludes generated datasets, database files and temporary files.

## 8. How to Run

Run the following commands from the project root in PowerShell:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt
python generate_data.py
jupyter notebook pesapap_analysis.ipynb
```

Run the notebook cells in order. Review the SQL results, KPI scorecard, customer segmentation, retention analysis, experiment results and generated growth memo.

## 9. Limitations

- The datasets are synthetic and do not represent actual PesaPap customers.
- Transaction dates are generated independently of signup dates, resulting in transactions before registration.
- Experiment group sizes differ: Group A has 1,443 participants and Group B has 1,557.
- The monthly impact estimate assumes the observed experiment effect generalises to future sign-ups.
- The confidence interval uses a normal approximation.
- Implementation costs and longer-term customer value are not included.

## 10. Conclusion

This project demonstrates an end-to-end analytical workflow, from data generation and SQL querying to customer segmentation, experiment evaluation and business recommendations. The findings support further testing and a monitored rollout of variant B, while highlighting the importance of data quality and ongoing performance monitoring.
