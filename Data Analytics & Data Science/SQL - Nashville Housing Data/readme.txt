Nashville Housing Data Cleanup Project Summary

This project is focused on demonstrating advanced SQL skills through the meticulous cleanup and organization of the Nashville housing dataset. The process begins with a basic data retrieval to preview the dataset structure and contents. Following this, a series of targeted SQL queries and commands are employed to enhance data quality and usability:

Standardizing Date Formats: The SaleDate field's format is standardized to ensure consistency across records, facilitating easier analysis and manipulation of date-related information.

Separating Addresses: Both property and owner addresses are dissected into more granular components—address, city, and state—enabling more detailed geographic analysis. This step includes adding new columns to store the separated address components, then updating the dataset with these refined values, specifically marking the state as 'TN' to reflect Tennessee.

Clarifying 'Sold as Vacant' Values: The binary indicators in the 'Sold as Vacant' field are transformed from 'Y' and 'N' to 'Yes' and 'No', respectively. This change enhances the readability of the dataset and makes it more user-friendly for analysis purposes.

Removing Duplicates: A critical step in data cleanup, duplicate records are identified and removed using a combination of the ROW_NUMBER() function and a common table expression (CTE). This ensures the dataset's uniqueness and reliability for subsequent analyses.

Dropping Non-usable Columns: Finally, to streamline the dataset and focus on the most relevant information, non-usable columns such as OwnerAddress, TaxDistrict, and the original PropertyAddress and SaleDate fields are removed.

This comprehensive cleanup process showcases not only the ability to perform fundamental SQL operations but also highlights more sophisticated techniques like working with CTEs, window functions, and dynamic data manipulation
