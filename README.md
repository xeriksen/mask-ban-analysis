# ENABLE-mask-ban-

Mask Ban Presentation Outline

I. Introduction —short 

•	A. Background and Context
•	Overview of mask mandates and bans in the context of public health.
•	Introduction to the North Carolina mask ban law.
•	B. Objectives of the Study
•	To predict the impact of the mask ban on immunocompromised individuals.
•	To identify potential risks and outcomes.
II. Literature Review

•	A. Mask Mandates and Public Health
•	Historical context and effectiveness of mask mandates.
•	Previous studies on the impact of mask policies.
•	The process of the mask bill becoming law
•	B. Immunocompromised Individuals and COVID-19
•	Definition and characteristics of immunocompromised individuals. Social determinants of health, etc 
•	Vulnerability of immunocompromised individuals to COVID-19 and other respiratory infections.

III. Methodology — include time periods 
•	A. Data Collection
•	Sources of data (e.g., CDC, New York Times , NC general assembly, etc ).
•	Types of data collected (e.g., masking adherence, infection rates, mortality rates, county social determinants of health).
•	B. Analytical Techniques
•	Correlations between variables were calculated
•	Statistical probability sampling with replacement using mask data.
•	R studio software was used for analysis.
•	C. Assumptions and Limitations
•	Assumptions made in the predictive models.
•	Potential limitations and biases in the study.

IV. Predictive Analysis
•	A. Current Situation Analysis
•	Baseline data on infection rates among immunocompromised individuals before the mask ban.
•	B. Model Predictions
•	Predicted covid rates post mask ban 
•	C. Scenario Analysis

V. Results
•	A. Summary of Findings
•	Key results from predictive models.
•	B. Interpretation of Results
•	What the results suggest about the impact of the mask ban on immunocompromised individuals.
•	C. Data Tables and Figures

VI. Discussion
•	A. Comparison with Other Studies
•	Compare my data with other masking studies I have found
•	B. Public Health Implications
•	Potential public health impacts of the mask ban on north Carolinians 
•	C. Ethical Considerations
•	Ethical implications of enforcing or lifting mask mandates.

VII. Conclusion
•	A. Summary of Key Points
•	Recap of the study's objectives, methodology, and findings.
•	B. Future Research Directions
•	Areas for further study and research gaps identified.
•	C. Final Remarks
•	Concluding thoughts on the importance of protecting vulnerable populations.

VIII. Q&A Session
•	Open floor for questions and discussions with the audience.

References — add using QR code 
•	Citing all sources used in the literature review and data analysis.













## NC HB 237 Mask ban and campaign refinance bill

### project is focused specfically who the NCmask ban will affect the most 
### Project Structure

- **/scripts/**: Contains all the scripts needed to reproduce the analysis. The scripts are intended to be run in order of their number.
- **/source_data/**: Contains publicly-available data used in the analytic pipeline.
- **/derived_data/**: Contains all processed data that results from our ./scripts/ pipeline.

### Abstract

The North Carolina mask ban, as outlined in NC HB 237, is set to have profound implications on marginalized communities. This legislation, which prohibits the use of masks in public spaces, could exacerbate existing health disparities among these populations. Historically, marginalized groups have faced significant barriers to healthcare access and higher rates of health-related issues. By restricting mask usage, the policy may increase the vulnerability of these communities to communicable diseases, particularly in pandemic situations. Furthermore, the ban could lead to increased stigmatization and social exclusion of individuals within these groups who rely on masks for protection, potentially leading to greater economic and social inequities. 

Access to protective measures like masks is crucial for public health, especially during pandemics. This project aims to highlight the anticipated disproportionate effects of the mask ban on these already vulnerable populations, underscoring the need for careful consideration and mitigation strategies to protect public health and human rights. For this analysis, we will use publicly available data to investigate how the mask ban policy intersects with the demographics and socioeconomic status of affected populations.

Research Question:
    How many immunocompromised people  and covid cautious people does the NC mask ban have the potential to affect?
                Later answer bigger research question..    
            How is the NC mask ban going to affect the immunocompromised people living in NC?
                
FOCUS 
Find:
NYtimes data: Masking rates by county
I dont know how I could get this data: Risk factors for covid by county
 These will be difficult to get circumventing tableau, find an github trying to make the dat more accessible however I am having issues with the code he wrote:
    Waste water data by county
    vaccine rates by county 
Can't find this data: Cenus data??  To compare vulnerabilities and socioeconomic variables
I don't think I want to include this data because it will be some hard to access for litlle gain for my project:Covid death rates by county 
if needed for 2020 covid rates: the data behiind the dashboard


Data found and I would like but dont know how to include 
nc vaccine data by county if I can find a way to get it from a source other than the tableau dashboard available online
immunosupression data from NIH by regions south includes all of nc
-immunosuppressed people(health issue/ medication) 2020 AI AJ ***Add socio
-immunosuppressed people(health issue/ medication) 2024

Import data
-Nytimes mask data
-Nytimes county data
-Nytimes covid rates data
-Nc department of health waste water data 2020
-NC department of health waste water data 2024 


Combine nytimes datasets using the fip
Trim data from NYtimes dataset to isolate NC data
 
Combine waste water data according to fip

Trim data too only include NC counties 
