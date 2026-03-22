**Understanding the Berka dataset**

* Financial information about Czech bank 
* Has 5300 bank clients, with 1,000,000 transactions 
* The bank has extended 700 loans and 900 credit cards



**Account Table - 4500** 

* Account ID in the following tables: Order, Transactions, Loan, (Disposition)
* Clients can have more than one account - clients and accounts are related together in disposition table

|**Column**|**Description**|**Notes**|
|-|-|-|
|account\_id|Identification of account||
|district\_id|Location of the branch||
|date|Date of the account's creation|YYMMDD|
|frequency|Frequency of statement issuance|"POPLATEK MESICNE" - Monthly Issuance<br /><br />"POPLATEK TYDNE" - Weekly Issuance<br /><br />"POPLATEK PO OBRATU" - Issuance After Transaction|





**Clients Table - 5369**

* Describes characteristics of persons who can manipulate with the accounts.

|**Column**|**Description**|**Notes**|
|-|-|-|
|client\_id|Client Identifier ||
|birt\_number|Birthday and Sex|The value is in the form: YYMMDD (for men)<br /><br />The value is in the form: YYMM+50DD (for women)<br />Where YYMMDD is the date of birth|
|district\_id|Address of the client||





**Disposition Table- 5369**

* Each record relates together a client with an account i.e. this relation describes the rights of clients to operate accounts
* Disponent refers to an authorized user who has been granted permission by the account owner to access and transact on a bank account. 
* While the disponent can manage funds, they are not the legal owner of the account - they can not do permanent orders or ask for loans 
* &nbsp;

|**Column**|**Description**|**Notes**|
|-|-|-|
|disp\_id|Record Identifier ||
|client\_id|client Identifier||
|account\_id|account Identifier||
|type|Type of Disposition (owner/user)|Only owner can issue permanent orders and ask for a loan|





**Orders Table (Debits only)**

* Money that has been taken out/deducted from the accounts 

|**Column**|**Description**|**Notes**|
|-|-|-|
|order\_id|Record Identifier||
|account\_id|Account the order is issued for||
|bank\_to|Bank of recipient |Each bank has a unique two-letter code|
|account\_to|Account of the recipient||
|amount|Amount debited from order account||
|k\_symbol|Characterization of the payment|'POJISTNE' stands for Insurance Payment<br /><br />'SIPO' stands for Household Payment<br /><br />'LEASING' stands for Leasing Payment<br /><br />'UVER' stands for Loan Payment|





**Transactions Table** 

* Includes both credit and debit transactions 

|**Column**|**Description** |**Notes** |
|-|-|-|
|trans\_id|Record Identifier||
|account\_id|Account the transaction is issued on||
|date|Date of transaction |In the form: YYMMDD|
|type|Type of transaction <br />debit/credit transaction|'PRIJEM' stands for Credit<br />'VYDAJ' stands for Debit (withdrawal)|
|operation|Mode of transaction|'VYBER KARTOU' stands for Credit Card Withdrawal<br /><br />'VKLAD' stands for Credit in Cash<br /><br />'PREVOD Z UCTU' stands for Collection from Another Bank<br /><br />'VYBER' stands for Withdrawal in Cash<br /><br />'PREVOD NA UCET' stands for Remittance to Another Bank|
|amount |Amount of transaction||
|balance|Balance of Account after transaction||
|k\_symbol|Characterization of transaction |'POJISTNE' stands for Insurance Payment<br /><br />'SLUZBY' stands for Payment of Statement<br /><br />'UROK' stands for Interest Credited<br /><br />'SANKC. UROK' stands for Sanction Interest if Negative Balance<br /><br />'SIPO' stands for Household Payment<br /><br />'DUCHOD' stands for Old-age Pension Payment<br /><br />'UVER' stands for Loan Payment|
|bank|Bank of partner |Each bank has unique two-letter code|
|account |Account of partner||





**Loan Table - 682**

* Describes the loans that were granted 

|**Column**|**Description** |**Notes**|
|-|-|-|
|disp\_id|Record Identifier||
|loan\_id|Record Identifier||
|account\_id|Account Identifier||
|date|Date loan was granted|In the form: YYMMDD|
|amount |Amount of loan||
|duration|Duration of loan||
|payments|Monthly payments on loan||
|status |status in paying off the loan|'A' stands for contract finished, no problems<br /><br />'B' stands for contract finished, loan not payed<br /><br />'C' stands for running contract, OK thus-far<br /><br />'D' stands for running contract, client in debt|



**Card Table - 892**

* Credit card issued to each account 

|**Column**|**Description** |**Notes**|
|-|-|-|
|card\_id|Card identifier||
|disp\_id|Disposition to an account||
|type|Type of card|Types are 'Junior', 'Classic', and 'Gold'|
|issued|Date card was issued|In the format: YYMMDD|





**Demograph Table - 77**



|**Column**|**Description**|**Notes**|
|-|-|-|
|A1 = district\_id|District Identifier||
|A2|District Name||
|A3|Region||
|A4|No. of Inhabitants||
|A5|No. of Municipalities with inhabitants < 499||
|A6|No. of Municipalities with inhabitants 500-1999||
|A7|No. of Municipalities with inhabitants 2000-9999||
|A8|No. of Municipalities with inhabitants > 10000||
|A9|No. of Cities||
|A10|Ratio of urban inhabitants||
|A11|Average Salary||
|A12|Unemployment rate in 1995||
|A13|Unemployment rate in 1996||
|A14|No. of Enterpreneurs per 1000 inhabitants||
|A15|No. of Crimes commited in 1995||
|A16|No. of Crimes commited in 1996||



