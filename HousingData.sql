/*

Cleaning Data in SQL Queries

*/

Select * From PortfolioProject.dbo.NashvilleHousing


-------------------------------------------------------


-- Standardize Date Format

Select SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing

Update PortfolioProject.dbo.NashvilleHousing
Set SaleDate = CONVERT(Date,SaleDate)

Alter Table dbo.NashVilleHousing
Add SaleDateConverted Date;

Update PortfolioProject.dbo.NashvilleHousing
Set SaleDateConverted = CONVERT(Date,SaleDate)

--------------------------------------------------------

-- Populate Property Address Data

Select *
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress Is Null
Order By ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null


----------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress Is Null
--Order By ParcelID

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) as Address
From PortfolioProject.dbo.NashvilleHousing



Alter Table dbo.NashVilleHousing
Add PropertySplitAddress Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1 )

Alter Table dbo.NashVilleHousing
Add PropertySplitCity Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

Select * From PortfolioProject.dbo.NashvilleHousing

-----------------------------------
/*Drop Column if you need to

Alter Table dbo.NashVilleHousing
Drop Column PropertySplitAddress

Alter Table dbo.NashVilleHousing
Drop Column PropertySplitCity

*/
------------------------------------


Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress,',', '.') ,3)
,PARSENAME(REPLACE(OwnerAddress,',', '.') ,2)
,PARSENAME(REPLACE(OwnerAddress,',', '.') ,1)
From PortfolioProject.dbo.NashvilleHousing


Alter Table dbo.NashVilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.') ,3)

Alter Table dbo.NashVilleHousing
Add OwnerSplitCity Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.') ,2)

Alter Table dbo.NashVilleHousing
Add OwnerSplitState Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', '.') ,1)


Select * From PortfolioProject.dbo.NashvilleHousing

---------------------------------------------------------------------------

-- Change y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group By SoldAsVacant
Order By 2

Select SoldAsVacant
, Case When SoldAsVacant = 'Y' Then 'Yes'
       When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   END
From PortfolioProject.dbo.NashvilleHousing


Update PortfolioProject.dbo.NashvilleHousing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
       When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   END

--------------------------------------------------------------------------------

-- Remove Duplicates
With RowNumCTE As(
Select *,
     ROW_NUMBER() OVER (
	 PARTITION BY ParcelID,
	              PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  Order By
				    UniqueID
					) row_num
From PortfolioProject.dbo.NashvilleHousing
--Order By ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order By PropertyAddress



---------------------------------------------------------------------------------

-- Delete Unused Columns


Select *
From PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop Column SaleDate

Select SoldAsVacant
 ,Case
     When SoldAsVacant = 1 Then 'Yes'
	 When SoldAsVacant = 0 Then 'No'
	 End as SoldAsVacant1
	 From PortfolioProject.dbo.NashvilleHousing




--------------------------------------------------

-- Had to Create a new column SoldAsVacant1 due to the original column only having 0 and 1 instead of Yes or New

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD SoldAsVacant1 nvarchar(255)

UPDATE PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant1 = 
    CASE
        WHEN SoldAsVacant = 1 THEN 'Yes'
        WHEN SoldAsVacant = 0 THEN 'No'
        ELSE NULL
    END;

------------------------------------------------------------

-- Dropped original column since I had the new column with the correct data
/*
Alter Table dbo.NashVilleHousing
Drop Column SoldAsVacant
*/


-- Used to rename the column from SoldAsVacant1 to SoldAsVacant

EXEC sp_rename 'PortfolioProject.dbo.NashvilleHousing.SoldAsVacant1', 'SoldAsVacant', 'COLUMN';




-------------------------------------------------------------
