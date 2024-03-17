This project expands on a simple linear regression analysis by incorporating an additional variable: attendance. It investigates the relationship between GPA, SAT scores, and class attendance, where attendance is quantified as a dummy variable (1 for students attending more than 75% of classes, 0 otherwise). This approach allows for a more nuanced exploration of the factors influencing academic performance.

The analysis utilizes the following libraries:

numpy: Included for potential future data operations, not directly used in this analysis.
pandas: For data handling and manipulation.
matplotlib.pyplot: For creating visual representations of our data and analysis results.
statsmodels.api: For performing the linear regression analysis.
seaborn: To enhance the aesthetics of the plots.

The dataset, sourced from Kaggle, includes three main variables:

GPA: Grade Point Average of students.
SAT: SAT scores of students.
Attendance: Dummy variable representing attendance (1 or 0).
The core analysis involves applying linear regression to understand how GPA can be predicted based on SAT scores and attendance. This model aims to identify the combined effect of these variables on academic performance.

The results, detailed in a Jupyter notebook, include a regression model summary and plots, offering insights into how GPA correlates with SAT scores and attendance. The analysis culminates in creating fake students to test the model's predictive capability.
