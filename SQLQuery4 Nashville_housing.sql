/*
Cleaning Data in SQL Queries
*/


SELECT * 
From ProtfolioProject.dbo.Nashville_Housing

-------------------------------------------------------------------
--Standardize Data format


SELECT SaleDateConverted, Convert(Date,SaleDate)
From ProtfolioProject.dbo.Nashville_Housing

Update Nashville_Housing 
set SaleDate =  Convert(Date,SaleDate)

Alter table Nashville_Housing 
ADD SaleDateConverted Date; 


Update Nashville_Housing 
set SaleDateConverted =  Convert(Date,SaleDate)


--------------------------------------------------------------------------
--populate Property address Date


SELECT *
From ProtfolioProject.dbo.Nashville_Housing
--Where Property_Address is null
Order by ParcelID


SELECT A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, isnull(A.PropertyAddress,B.PropertyAddress)
From ProtfolioProject.dbo.Nashville_Housing A
join ProtfolioProject.dbo.Nashville_Housing B
	on A.ParcelID = B.ParcelID
	AND A.UniqueID <> B.UniqueID
Where A.PropertyAddress is null


update A
set PropertyAddress = isnull(A.PropertyAddress,B.PropertyAddress)
From ProtfolioProject.dbo.Nashville_Housing A
join ProtfolioProject.dbo.Nashville_Housing B
	on A.ParcelID = B.ParcelID
	AND A.UniqueID <> B.UniqueID
Where A.PropertyAddress is null

-----------------------------------------------------------------------------------
--Breaking out Address into individual columns (Address, City, State)


SELECT PropertyAddress
From ProtfolioProject.dbo.Nashville_Housing
--Where Property_Address is null
--Order by ParcelID

SELECT 
SUBSTRING(PropertyAddress, 1,  CHARINDEX(',', PropertyAddress)-1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address

FROM ProtfolioProject.dbo.Nashville_Housing



Alter table Nashville_Housing 
ADD PropertySplitAddress Nvarchar(255); 


Update Nashville_Housing 
SET PropertySplitAddress =  SUBSTRING(PropertyAddress, 1,  CHARINDEX(',', PropertyAddress)-1 )


Alter table Nashville_Housing 
ADD PropertySplitCity Nvarchar(255); 


Update Nashville_Housing 
set PropertySplitCity =  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))


SELECT * 
FROM ProtfolioProject.dbo.Nashville_Housing



SELECT OnerAddress
FROM ProtfolioProject.dbo.Nashville_Housing


SELECT
PARSENAME(REPLACE(OnerAddress, ',', '.'),3)
,PARSENAME(REPLACE(OnerAddress, ',', '.'),2)
,PARSENAME(REPLACE(OnerAddress, ',', '.'),1)
FROM ProtfolioProject.dbo.Nashville_Housing



Alter table Nashville_Housing 
ADD OwnerSplitAddress Nvarchar(255); 


Update Nashville_Housing 
SET OwnerSplitAddress =  PARSENAME(REPLACE(OnerAddress, ',', '.'),3)


Alter table Nashville_Housing 
ADD OwnerSplitCity Nvarchar(255); 


Update Nashville_Housing 
set OwnerSplitCity =  PARSENAME(REPLACE(OnerAddress, ',', '.'),2)

Alter table Nashville_Housing 
ADD OwnerSplitState Nvarchar(255); 


Update Nashville_Housing 
SET OwnerSplitState =  PARSENAME(REPLACE(OnerAddress, ',', '.'),1)


SELECT * 
FROM ProtfolioProject.dbo.Nashville_Housing



-----------------------------------------------------------------------------
--Change Y and N To Yes and No " Sold As Vacant"

SELECT DISTINCT(SoldAsVacant), Count(SoldAsVacant)
FROM ProtfolioProject.dbo.Nashville_Housing
Group by (SoldAsVacant)
Order by 2


SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   Else SoldAsVacant
	  END
FROM ProtfolioProject.dbo.Nashville_Housing


Update Nashville_Housing
SET SoldAsVacant =  CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   Else SoldAsVacant
	  END

-------------------------------------------------------------------------------
--Remove Duplicates



WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 LegalReference
				 ORDER BY
				   UniqueID
				   ) row_num

FROM ProtfolioProject.dbo.Nashville_Housing
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
Where row_num > 1
Order by PropertyAddress


WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 LegalReference
				 ORDER BY
				   UniqueID
				   ) row_num

FROM ProtfolioProject.dbo.Nashville_Housing
--ORDER BY ParcelID
)
Delete
FROM RowNumCTE
Where row_num > 1
--Order by PropertyAddress



WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 LegalReference
				 ORDER BY
				   UniqueID
				   ) row_num

FROM ProtfolioProject.dbo.Nashville_Housing
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
Where row_num > 1
Order by PropertyAddress



select *
FROM ProtfolioProject.dbo.Nashville_Housing


-------------------------------------------------------------------------------
--Delete Unused Columns

select *
FROM ProtfolioProject.dbo.Nashville_Housing


ALTER Table ProtfolioProject.dbo.Nashville_Housing
Drop Column  OnerAddress, TaxDistrict, PropertyAddress

ALTER Table ProtfolioProject.dbo.Nashville_Housing
Drop Column  SaleDate

--------It's Done-------------