select *
from PortfolioProject.dbo.NashvilleHousing




-- Standardize Date Format 

select SaleDateconverted, convert(date, saledate)
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
set saleDate = convert(date, SaleDate)

alter table NashvilleHousing
add SaleDateconverted Date;

update NashvilleHousing
set SaleDateconverted = convert(date, SaleDate)




--Populate Property Address data

select *
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID



select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a 
join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null



update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a 
join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null




-- Breaking out Address into Individual Columns (Addres, City, State)


select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID


select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address

from PortfolioProject.dbo.NashvilleHousing


alter table NashvilleHousing
add PropertysplitAdress varchar(255);

update NashvilleHousing
set PropertysplitAdress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) 


alter table NashvilleHousing
add PropertysplitCity varchar(255);

update NashvilleHousing
set PropertysplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))


select *
from PortfolioProject.dbo.NashvilleHousing




select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing



select 
PARSENAME(Replace(OwnerAddress, ',', '.') ,3)
,PARSENAME(Replace(OwnerAddress, ',', '.') ,2)
,PARSENAME(Replace(OwnerAddress, ',', '.') ,1)
from PortfolioProject.dbo.NashvilleHousing


alter table NashvilleHousing
add OwnersplitAdress varchar(255);

update NashvilleHousing
set OwnersplitAdress = PARSENAME(Replace(OwnerAddress, ',', '.') ,3)


alter table NashvilleHousing
add OwnersplitState varchar(255);

update NashvilleHousing
set OwnersplitState = PARSENAME(Replace(OwnerAddress, ',', '.') ,1)



alter table NashvilleHousing
add OwnersplitCity varchar(255);

update NashvilleHousing
set OwnersplitCity = PARSENAME(Replace(OwnerAddress, ',', '.') ,2)




select *
from PortfolioProject.dbo.NashvilleHousing




--Change Y and N to Yes and No in "Sold as Vacant" field




select distinct(SoldasVacant), count(SoldasVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2


select SoldasVacant
, case when SoldasVacant = 'Y' then 'Yes'
when SoldasVacant = 'N' then 'No'
else SoldAsVacant
end
from PortfolioProject.dbo.NashvilleHousing


update NashvilleHousing
set SoldAsVacant =  case when SoldasVacant = 'Y' then 'Yes'
when SoldasVacant = 'N' then 'No'
else SoldAsVacant
end





--Remove Duplicates


with RowNumCTE as (
select *, 
	ROW_NUMBER() over(
	partition by ParcelId,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by
					UniqueId
					) row_num

from PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
delete
from RowNumCTE
where row_num > 1
--order by PropertyAddress







--Deleting Unused Columns




select *
from PortfolioProject.dbo.NashvilleHousing


alter table PortfolioProject.dbo.NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress


alter table PortfolioProject.dbo.NashvilleHousing
drop column SaleDate