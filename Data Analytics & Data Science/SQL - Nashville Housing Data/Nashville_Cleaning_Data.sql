-- Data Cleaning Using SQL
SELECT *
FROM `new_schema`.`nashville housing`
LIMIT 5;


-- Standardize the Date Format for SaleDate and Updating the Change
SELECT SaleDate, STR_TO_DATE(SaleDate, '%M %d, %Y') AS saleDateConverted
FROM `new_schema`.`nashville housing`;

UPDATE `new_schema`.`nashville housing`
SET SaleDate = STR_TO_DATE(SaleDate, '%M %d, %Y');

-- Seperating Address for Property

SELECT
  SUBSTRING_INDEX(PropertyAddress, ',', 1) AS Address,
  TRIM(SUBSTRING_INDEX(PropertyAddress, ',', -1)) AS City
FROM `new_schema`.`nashville housing`;

ALTER TABLE `new_schema`.`nashville housing`
ADD COLUMN `PropertyAddress` VARCHAR(255),
ADD COLUMN `PropertyCity` VARCHAR(255),
ADD COLUMN `ProState` CHAR(2);

UPDATE `new_schema`.`nashville housing`
SET `Address` = SUBSTRING_INDEX(PropertyAddress, ',', 1),
    `City` = TRIM(SUBSTRING_INDEX(PropertyAddress, ',', -1)),
    `State` = 'TN';


-- Seperating Address for Owner Property

SELECT
  SUBSTRING_INDEX(OwnerAddress, ',', 1) AS Address,
  TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1)) AS City
FROM `new_schema`.`nashville housing`;

ALTER TABLE `new_schema`.`nashville housing`
ADD COLUMN `OwnerAddress` VARCHAR(255),
ADD COLUMN `OwnerCity` VARCHAR(255),
ADD COLUMN `OwnerState` CHAR(2);

UPDATE `new_schema`.`nashville housing`
SET `OwnerAddress` = SUBSTRING_INDEX(PropertyAddress, ',', 1),
    `OwnerCity` = TRIM(SUBSTRING_INDEX(PropertyAddress, ',', -1)),
    `OwnerState` = 'TN';
    
-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT SoldAsVacant, COUNT(SoldAsVacant)
FROM `new_schema`.`nashville housing`
GROUP BY SoldAsVacant
ORDER BY 2;

SELECT SoldAsVacant,
       CASE 
           WHEN SoldAsVacant = 'Y' THEN 'Yes'
           WHEN SoldAsVacant = 'N' THEN 'No'
           ELSE SoldAsVacant
       END
FROM `new_schema`.`nashville housing`;

UPDATE `new_schema`.`nashville housing`
SET SoldAsVacant = CASE 
                      WHEN SoldAsVacant = 'Y' THEN 'Yes'
                      WHEN SoldAsVacant = 'N' THEN 'No'
                      ELSE SoldAsVacant
                   END;

-- Remove Duplicates

WITH RowNumCTE AS (
  SELECT *,
         ROW_NUMBER() OVER (
           PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
           ORDER BY UniqueID
         ) AS row_num
  FROM `new_schema`.`nashville housing`
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress;


WITH RowNumCTE AS (
  SELECT *,
         ROW_NUMBER() OVER (
           PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
           ORDER BY UniqueID
         ) AS row_num
  FROM `new_schema`.`nashville housing`
)
DELETE FROM `new_schema`.`nashville housing`
WHERE UniqueID IN (
  SELECT UniqueID
  FROM RowNumCTE
  WHERE row_num > 1
);


SELECT *
FROM `new_schema`.`nashville housing`;

-- Delete Nonusable Columns

ALTER TABLE `new_schema`.`nashville housing`
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate;

Select *
From `new_schema`.`nashville housing`;


