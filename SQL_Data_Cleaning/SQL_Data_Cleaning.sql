/* Data Cleaning using SQL*/

select * from Portfolio_Project..Nashville_Housing

---------------------------------------------------------------------

--Standarize Date Format

select SaleDate
--, CAST(SaleDate as Date) as Sale_Date_New
from Portfolio_Project..Nashville_Housing


alter table Portfolio_Project..Nashville_Housing alter column saleDate Date;


----------------------------------------------------------------------

--Populate Property Address data

select * from Portfolio_Project..Nashville_Housing

--Actual Update Query

update a set propertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from Portfolio_Project..Nashville_Housing a 
join Portfolio_Project..Nashville_Housing b on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null;

--Checking Purpose written this query

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress from Portfolio_Project..Nashville_Housing a 
join Portfolio_Project..Nashville_Housing b on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--Spilt PropertyAddress column into two columns

-- Cross Check the data for split propertyAddress column

select SUBSTRING(propertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(propertyAddress,CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
from Portfolio_Project..Nashville_Housing

--ADD two new column and add the splitting data into this new columns respectively.

Alter table Portfolio_Project..Nashville_Housing
add splitPropertyAddress  nvarchar(255);

update Portfolio_Project..Nashville_Housing set 
splitPropertyAddress = SUBSTRING(propertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

Alter table Portfolio_Project..Nashville_Housing
add splitPropertyCity  nvarchar(255);

update Portfolio_Project..Nashville_Housing set 
splitPropertyCity = SUBSTRING(propertyAddress,CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

-----------------------------------------------------------------------

--Breaking out Address into Individual Columns (Address, City, State)


select * from  Portfolio_Project..Nashville_Housing;

select OwnerAddress from  Portfolio_Project..Nashville_Housing;

select PARSENAME(REPLACE(OwnerAddress,',','.'),3) as address,
PARSENAME(REPLACE(OwnerAddress,',','.'),2) as city,
PARSENAME(REPLACE(OwnerAddress,',','.'),1) as state
from Portfolio_Project..Nashville_Housing;

Alter table Portfolio_Project..Nashville_Housing
add splitOwnerAddress  nvarchar(255);

update Portfolio_Project..Nashville_Housing set splitOwnerAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Alter table Portfolio_Project..Nashville_Housing
add splitOwnerCity  nvarchar(255);

update Portfolio_Project..Nashville_Housing set splitOwnerCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

Alter table Portfolio_Project..Nashville_Housing
add splitOwnerState  nvarchar(255);

update Portfolio_Project..Nashville_Housing set splitOwnerState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)



------------------------------------------------------------------------

--Change Y & N to Yes and No in "Sold as Vacant" field


select SoldAsVacant, count(SoldAsVacant) from  Portfolio_Project..Nashville_Housing group by SoldAsVacant;

update Portfolio_Project..Nashville_Housing set soldAsVacant = 
CASE(soldAsVacant)
when 'Y' then 'Yes'
when 'N' then 'No'
else soldAsVacant
end

--------------------------------------------------------------------------

--Remove Duplicates
select * from Portfolio_Project..Nashville_Housing

with cte as(
select *,
row_number() over(partition by 
parcelID,
propertyAddress,
SaleDate,
SalePrice,
LegalReference
order by UniqueID
)as rnk_num
from Portfolio_Project..Nashville_Housing
)
delete from cte where rnk_num >1





---------------------------------------------------------------------------

--Remove Unused Columns


alter table Portfolio_Project..Nashville_Housing drop column propertyAddress, ownerAddress


select * from Portfolio_Project..Nashville_Housing





-----------------------------------------------------------------------------