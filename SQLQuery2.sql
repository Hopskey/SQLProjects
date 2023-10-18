---cleaning data in sql

select * from PortfolioProject..NashvilleProperties


---Standardized date
select SaleDate, CONVERT(Date,saledate)
from PortfolioProject..NashvilleProperties

Update PortfolioProject..NashvilleProperties
Set SaleDate = Convert(Date,Saledate)

Alter table PortfolioProject..NashvilleProperties
Add SaleDateConverted Date;

Update PortfolioProject..NashvilleProperties
Set SaleDateConverted = CONVERT(date,SaleDate)

select SaleDateConverted, CONVERT(Date,SaleDate)
from PortfolioProject..NashvilleProperties


----Populate Property Address
select PropertyAddress from PortfolioProject..NashvilleProperties

--check for null values
select * from PortfolioProject..NashvilleProperties
--where PropertyAddress is null
ORDER BY	ParcelID

--Self join to check for null values
select a.PropertyAddress,a.ParcelID,b.ParcelID,b.PropertyAddress , ISNULL(a.PropertyAddress,b.PropertyAddress) UpdatedPropertyAddress
from PortfolioProject..NashvilleProperties a
join PortfolioProject..NashvilleProperties b
on a.ParcelID = b.ParcelID 
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

Update a --updating the address to remove null values
Set propertyaddress = ISNULL(a.PropertyAddress,b.PropertyAddress) 
from PortfolioProject..NashvilleProperties a
join PortfolioProject..NashvilleProperties b
on a.ParcelID = b.ParcelID 
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

-----------------------
-- Breaking out address into indiviual columns
select PropertyAddress 
from PortfolioProject..NashvilleProperties

select
SUBSTRING(propertyaddress,1,charindex(',',propertyaddress)-1)as address --charindex gives out value ofposition of character in teh string
, SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1,len(PropertyAddress)) as address
from PortfolioProject..NashvilleProperties

--adding the columns

Alter table PortfolioProject..NashvilleProperties
Add AddressProp varchar(250);

Update PortfolioProject..NashvilleProperties
Set AddressProp =SUBSTRING(propertyaddress,1,charindex(',',propertyaddress)-1)

Alter table PortfolioProject..NashvilleProperties
Add AddressCity varchar(250);

Update PortfolioProject..NashvilleProperties
Set addresscity = SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1,len(PropertyAddress))

select * from PortfolioProject..NashvilleProperties

--Owner Address--
select owneraddress from PortfolioProject..NashvilleProperties

select PARSENAME(REPLACE(owneraddress,',','.'),3),
		Parsename(replace(owneraddress,',','.'),2),
		Parsename(replace(owneraddress,',','.'),1)
		from portfolioProject..NashvilleProperties

Alter table PortfolioProject..NashvilleProperties
Add onwersplitaddress varchar(250);

Update PortfolioProject..NashvilleProperties
Set onwersplitaddress =PARSENAME(REPLACE(owneraddress,',','.'),3)

Alter table PortfolioProject..NashvilleProperties
add ownersplitcity varchar(250);

Update PortfolioProject..NashvilleProperties
Set ownersplitcity =PARSENAME(REPLACE(owneraddress,',','.'),2)

Alter table PortfolioProject..NashvilleProperties
add ownersplitstate varchar(250);

Update PortfolioProject..NashvilleProperties
Set ownersplitstate =PARSENAME(REPLACE(owneraddress,',','.'),1)


Select * from PortfolioProject..NashvilleProperties


-----------change Y and N from yes and nO

Select Distinct(Soldasvacant),count(soldasvacant) 
from PortfolioProject..NashvilleProperties
group by SoldAsVacant
order by 2

select soldasvacant,
case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else soldasvacant
	end
from PortfolioProject..NashvilleProperties
	
Update PortfolioProject..NashvilleProperties
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else soldasvacant
	end

select * from PortfolioProject..NashvilleProperties

----------------------------------------------------\

--remove duplicates

--with RowNumCTE as 
--(
--select *, ROW_NUMBER() over
--(partition by parcelID,
--				PropertyAddress,
--				SalePrice,
--				SaleDate,
--				LegalReference
--				order by
--				uniqueid) rownum										
--from PortfolioProject..NashvilleProperties)


--delete 
--from RowNumCTE 
--where rownum > 1


---------------------Drop cplumns

Alter table PortfolioProject..NashvilleProperties
drop column owneraddress, Saledate, Propertyaddress