Select * 
from dbo.housing101

--------------------------------------------------------------------------------------------------------
--Standardizing Date Format
Select SaleDate, CONVERT(Date, SaleDate)
From housing101


Alter Table housing101
Alter Column SaleDate Date

-------------------------------------------------------------------------------------------------------
--Populate Property Address data
Select *
From housing101
Where PropertyAddress is null

Select a.ParcelID,a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from housing101 a
join housing101 b
     ON a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--Populating null values 
Update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from housing101 a
join housing101 b
     ON a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


-------------------------------------------------------------------------------------------------

--Breaking out Address into individual column
Select PropertyAddress
From housing101


Select SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))
from housing101



Alter Table housing101
Add PropertysplitAddress Nvarchar(255)

Update housing101
Set PropertysplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

Alter Table housing101
Add PropertysplitCity Nvarchar(255)

Update housing101
Set PropertysplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

Select *
from housing101

Select 
PARSENAME(Replace(OwnerAddress,',','.'),3) as Address,
PARSENAME(Replace(OwnerAddress,',','.'),2) as City,
PARSENAME(Replace(OwnerAddress,',','.'),1) as State
from housing101

Alter Table housing101
Add OwnersplitAddress Nvarchar(255)

Update housing101
Set OwnersplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3) 


Alter Table housing101
Add OwnersplitCity Nvarchar(255)

Update housing101
Set OwnersplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2) 

Alter Table housing101
Add OwnersplitState Nvarchar(255)

Update housing101
Set OwnersplitState = PARSENAME(Replace(OwnerAddress,',','.'),1) 


---------------------------------------------------------------------------------------------------------------
--Change Y and N to Yes and No in Sold as vacent field

Select SoldAsVacant,
Case When SoldAsVacant = 'Y' Then 'Yes'
     When SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 End
from housing101

Update housing101
Set SoldAsVacant =
Case When SoldAsVacant = 'Y' Then 'Yes'
     When SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 End
from housing101


------------------------------------------------------------------------------------------------------------
--Removing duplicates

Select *
from housing101

With RowNumCTE As (
Select *,
       ROW_NUMBER() Over(
	   Partition By ParcelID,
	           PropertyAddress,
			   SalePrice,
			   SaleDate,
			   LegalReference
			   Order By UniqueID
			   ) row_num
from housing101
)
Delete
from RowNumCTE
Where row_num >1
--Order By PropertyAddress


--------------------------------------------------------------------------------------------------------------
--Delete Unused columns

Alter Table housing101
Drop Column OwnerAddress,
            TaxDistrict,
			PropertyAddress


	           
	   



