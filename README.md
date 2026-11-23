This was a personal project I designed to showcase my financial analytical skills. I analysed a real-world banking dataset from Czech Bank. 
The dataset, also known as the Berka dataset contains anonymised transactional data from 1993 to 1999, including over 1 million transactions, 5,369 clients, and 682 loans across 77 districts.

** Business Question:**
How can Czech Bank grow its lending book without increasing credit losses, and which customers and districts should it prioritise 

**To answer the business question the analysis focused on meeting the following objectives:**
  
  - Understand who are Czech Bank’s customers; their demographics, location and account types
  
  - Analyse 1million + transactions to understand spending behaviour and account activity and trends over time 
  
  - Analyse the bank's loan book, the distribution of loan sizes, durations, repayment statuses, and the profile of borrowers. 
  
  - I analysed the dataset on SQL and presented my findings on PowerPoint

**Recommendations after analysis:**

- Tier lending by size and instalment burden. Apply standard approval below 200K. Above it, require an affordability check and added security. Cap instalments relative to monthly inflow, with the threshold set by back-testing.

- Grow first among existing relationships. Offer pre-approved moderate loans to the ~720 card-only accounts, and pilot cards for loan-only customers as a controlled test.

- Prioritise Prague, then the larger, higher-salary districts. Use a scorecard of penetration per 1,000 inhabitants, salary, unemployment and sample size, and avoid judging districts on small loan counts.
  
- Treat weekly-statement clients as a relationship segment. Offer cards and savings first, and lend once balances and income are verified.

- Time credit decisions to the seasonal cycle. Avoid large limit increases before the December-January peak, and focus early collections on the ~6.5% of loans running behind.
