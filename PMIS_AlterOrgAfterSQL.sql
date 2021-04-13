update [dbo].[FM7T_PMIS_L]
set ApproverDept = q.DeptID
from (
        select *
        from [dbo].[EFC_CurrentMember]
    ) q
where ApproverID = q.AccountID
GO


update [dbo].FM7T_PMIS_M
set ApplicantDept = q.DeptID
from (
        select *
        from [dbo].[EFC_CurrentMember]
    ) q
where ApplicantID = q.AccountID
GO

update [dbo].FM7T_PMIS_M
set FillerDept = q.DeptID
from (
        select *
        from [dbo].[EFC_CurrentMember]
    ) q
where FillerID = q.AccountID
GO

update [dbo].FM7T_PMIS_S
set ApproverDept = q.DeptID
from (
        select *
        from [dbo].[EFC_CurrentMember]
    ) q
where ApproverID = q.AccountID
GO

update [dbo].FM7T_PMIS_S
set ApproverDeptName = q.DeptName
from (
        select *
        from [dbo].[EFC_CurrentMember]
    ) q
where ApproverID = q.AccountID
GO

update [dbo].FM7T_PMIS_S
set ApproverName = q.AccountName
from (
        select *
        from [dbo].[EFC_CurrentMember]
    ) q
where ApproverID = q.AccountID
GO

update [dbo].FSe7en_Sys_ApprovalLog
set ApproverDept = q.DeptID
from (
        select *
        from [dbo].[EFC_CurrentMember]
    ) q
where ApproverID = q.AccountID
GO
update [dbo].FSe7en_Sys_FatalApprover
set ApproverDept = q.DeptID
from (
        select *
        from [dbo].[EFC_CurrentMember]
    ) q
where ApproverID = q.AccountID
GO

update [dbo].FSe7en_Sys_ForeseeResult
set ApproverDept = q.DeptID
from (
        select *
        from [dbo].[EFC_CurrentMember]
    ) q
where ApproverID = q.AccountID
GO


update [dbo].FSe7en_Sys_NextApprover
set ApproverDept = q.DeptID
from (
        select *
        from [dbo].[EFC_CurrentMember]
    ) q
where ApproverID = q.AccountID
GO



update [dbo].FSe7en_Sys_Requisition
set DeptID = q.DeptID
from (
        select *
        from [dbo].[EFC_CurrentMember]
    ) q
where AccountID = q.AccountID
GO

update [dbo].FSe7en_Sys_RollBackInfo
set ApproverDept = q.DeptID
from (
        select *
        from [dbo].[EFC_CurrentMember]
    ) q
where ApproverID = q.AccountID
GO

update [dbo].ntLIBs2_sys_Files_DBCOPY_InDB_log
set ApplyerDeptID = q.DeptID
from (
        select *
        from [dbo].[EFC_CurrentMember]
    ) q
where ApplyID = q.AccountID
GO

update [dbo].WS02_OS
set ParentDeptID = q.DeptID
from (
        select *
        from [dbo].[EFC_CurrentMember]
    ) q
where PMID = q.AccountID
GO


update [dbo].WS02_OS
set ParentDeptName = q.DeptName
from (
        select *
        from [dbo].[EFC_CurrentMember]
    ) q
where PMID = q.AccountID
GO

update [dbo].WS02_OS
set ParentSavedValue = q.DeptID+'@'+q.ParentDeptID
from (
        select *
        from [dbo].[EFC_CurrentMember]
    ) q
where PMID = q.AccountID
GO





update [dbo].WS02_OS
set PMName = q.AccountName
from (
        select *
        from [dbo].[EFC_CurrentMember]
    ) q
where PMID = q.AccountID
GO



update [dbo].WS02_OS
set PMName_sub = q.AccountName
from (
        select *
        from [dbo].[EFC_CurrentMember]
    ) q
where PMID_sub = q.AccountID
GO



update [dbo].WS02_OS_DetailReply_Manpower
set EmployeeName = q.AccountName
from (
        select *
        from [dbo].[EFC_CurrentMember]
    ) q
where EmployeeID = q.AccountID
GO

update [dbo].WS02_OS_DetailReply_Manpower
set EmployeeSavedValue = EmployeeID + '@' + q.AccountName
from (
        select *
        from [dbo].[EFC_CurrentMember]
    ) q
where EmployeeID = q.AccountID
GO

update [dbo].WS02_OS_UserDesignFieldSearch
set DeptID = q.DeptID
from (
        select *
        from [dbo].[EFC_CurrentMember]
    ) q
where WS02_OS_UserDesignFieldSearch.AccountID = q.AccountID
    and WS02_OS_UserDesignFieldSearch.DeptID is not null
GO


update [dbo].WS02_OS
set PMSavedValue = q.AccountID + '@' + q.DeptID
from (
        select *
        from [dbo].[EFC_CurrentMember]
    ) q
where PMID = q.AccountName
GO

update [dbo].WS02_OS
set PMSavedValue_sub = q.AccountID + '@' + q.DeptID
from (
        select *
        from [dbo].[EFC_CurrentMember]
    ) q
where PMID_sub = q.AccountName
GO


DECLARE MyCursor CURSOR FOR
select AutoCounter
from FSe7en_Sys_NextApprover Open MyCursor --定義ID變數
declare @AutoCounter nvarchar(500) --用來存放ID的變數
	--開始迴圈跑Cursor Start
	Fetch NEXT
FROM MyCursor INTO @AutoCounter While (@@FETCH_STATUS <> -1) BEGIN
declare @StrA nvarchar(max)
declare @StrB nvarchar(max)
declare @TmpA nvarchar(max) --此區塊就可以處理商業邏輯，譬如利用tableA的ID將資料塞入tableB
select @StrA =(
		select top 1 ApprovalHistory
		from FSe7en_Sys_NextApprover
		where AutoCounter = @AutoCounter
	)
select @TmpA =(
		select substring(Data, 0, CHARINDEX('[', Data)) + '[' +(
				substring(
					Data,
					CHARINDEX('[', Data) + 1,
					CHARINDEX ('@', Data) - CHARINDEX('[', Data) -1
				) + '@' + (
					select DeptID
					from [dbo].[EFC_CurrentMember]
					where AccountID = substring(
							Data,
							CHARINDEX('[', Data) + 1,
							CHARINDEX ('@', Data) - CHARINDEX('[', Data) -1
						)
				)
			) + ']' + '/'
		from [dbo].[SplitString](@StrA, '/') for xml path('')
	)
update FSe7en_Sys_NextApprover
SET ApprovalHistory = [dbo].[fn_RemoveLastChar](@TmpA)
where AutoCounter = @AutoCounter Fetch NEXT
FROM MyCursor INTO @AutoCounter
END --開始迴圈跑Cursor End
--關閉&釋放cursor
CLOSE MyCursor DEALLOCATE MyCursor
GO



DECLARE MyCursor CURSOR FOR
select [MenuID]
from [dbo].[PMIS_MyPage_Menu]
where len (OpenSavedValue) > 1 Open MyCursor --定義ID變數
declare @MenuID nvarchar(500) --用來存放ID的變數
	--開始迴圈跑Cursor Start
	Fetch NEXT
FROM MyCursor INTO @MenuID While (@@FETCH_STATUS <> -1) BEGIN
declare @StrA nvarchar(max)
declare @StrB nvarchar(max)
declare @TmpA nvarchar(max) --此區塊就可以處理商業邏輯，譬如利用tableA的ID將資料塞入tableB
select @StrA =(
		select top 1 OpenSavedValue
		from [dbo].[PMIS_MyPage_Menu]
		where MenuID = @MenuID
	)
select @TmpA =(
		select substring(Data, 0, CHARINDEX('@', Data)) ---orginal value
			+ '@' + (
				select DeptID
				from [dbo].[EFC_CurrentMember]
				where AccountID = substring(Data, 0, CHARINDEX('@', Data))
			) + ','
		from [dbo].[SplitString](@StrA, ',') for xml path('')
	)
update [PMIS_MyPage_Menu]
SET OpenSavedValue = [dbo].[fn_RemoveLastChar](@TmpA)
where MenuID = @MenuID Fetch NEXT
FROM MyCursor INTO @MenuID
END --開始迴圈跑Cursor End
--關閉&釋放cursor
CLOSE MyCursor DEALLOCATE MyCursor
GO



DECLARE MyCursor CURSOR FOR
select UniqueID
from [dbo].WS02_OS
where len (OthersNotifyID) > 1 Open MyCursor --�w�qID�ܼ�
declare @UniqueID nvarchar(500) --�ΨӦs��ID���ܼ�
	--�}�l�j��]Cursor Start
	Fetch NEXT
FROM MyCursor INTO @UniqueID While (@@FETCH_STATUS <> -1) BEGIN
declare @StrA nvarchar(max)
declare @StrB nvarchar(max)
declare @TmpA nvarchar(max)
declare @TmpB nvarchar(max)
declare @TmpC nvarchar(max) --���϶��N�i�H�B�z�ӷ~�޿�AĴ�p�Q��tableA��ID�N��ƶ�JtableB
select @StrA =(
		select top 1 OthersNotifyID
		from [dbo].WS02_OS
		where UniqueID = @UniqueID
	)
select @TmpA =(
		select Data + '@' + (
				select DeptID
				from [dbo].[EFC_CurrentMember]
				where AccountID = Data
			) + ','
		from [dbo].[SplitString](@StrA, ',') for xml path('')
	)
select @TmpB =(
		select (
				select AccountName
				from [dbo].[EFC_CurrentMember]
				where AccountID = Data
			) + ','
		from [dbo].[SplitString](@StrA, ',') for xml path('')
	)
update WS02_OS
SET OthersNotifyName = [dbo].[fn_RemoveLastChar](@TmpB),
	OthersNotifyValue = [dbo].[fn_RemoveLastChar](@TmpA)
where UniqueID = @UniqueID Fetch NEXT
FROM MyCursor INTO @UniqueID
END --�}�l�j��]Cursor End
--����&����cursor
CLOSE MyCursor DEALLOCATE MyCursor
GO






DECLARE MyCursor CURSOR FOR
select UniqueID
from [dbo].WS02_OS_Detail
where len (SpecifyID) > 1 Open MyCursor --�w�qID�ܼ�
declare @UniqueID nvarchar(500) --�ΨӦs��ID���ܼ�
	--�}�l�j��]Cursor Start
	Fetch NEXT
FROM MyCursor INTO @UniqueID While (@@FETCH_STATUS <> -1) BEGIN
declare @StrA nvarchar(max)
declare @StrB nvarchar(max)
declare @TmpA nvarchar(max)
declare @TmpB nvarchar(max) --���϶��N�i�H�B�z�ӷ~�޿�AĴ�p�Q��tableA��ID�N��ƶ�JtableB
select @StrA =(
		select top 1 SpecifyID
		from [dbo].WS02_OS_Detail
		where UniqueID = @UniqueID
	) --select  @StrA
select @TmpA =(
		select ---orginal value
			--+'['
			--+( substring(Data,CHARINDEX('[',   Data)+1,    CHARINDEX ( '@' , Data )-CHARINDEX('[', Data)-1 )
			(
				select AccountName
				from [dbo].[EFC_CurrentMember]
				where AccountID = Replace(Data, '^', '') --)
			) + ','
		from [dbo].[SplitString](@StrA, ',') for xml path('')
	)
select @TmpB =(
		select ---orginal value
			--+'['
			--+( substring(Data,CHARINDEX('[',   Data)+1,    CHARINDEX ( '@' , Data )-CHARINDEX('[', Data)-1 )
			(
				select AccountID
				from [dbo].[EFC_CurrentMember]
				where AccountID = Replace(Data, '^', '')
			) + '@' + (
				select DeptID
				from [dbo].[EFC_CurrentMember]
				where AccountID = Replace(Data, '^', '') --)
			) + ','
		from [dbo].[SplitString](@StrA, ',') for xml path('')
	)
update WS02_OS_Detail
SET SpecifyName = [dbo].[fn_RemoveLastChar](@TmpA),
	SpecifySavedValue = [dbo].[fn_RemoveLastChar](@TmpB)
where UniqueID = @UniqueID Fetch NEXT
FROM MyCursor INTO @UniqueID
END --�}�l�j��]Cursor End
--����&����cursor
CLOSE MyCursor DEALLOCATE MyCursor
Go

DECLARE MyCursor CURSOR FOR
select [AutoCounter]
from [dbo].[WS02_OS_RoleSetting]
where len ([MemberID]) > 1 Open MyCursor --定義ID變數
declare @AutoCounter nvarchar(500) --用來存放ID的變數
	--開始迴圈跑Cursor Start
	Fetch NEXT
FROM MyCursor INTO @AutoCounter While (@@FETCH_STATUS <> -1) BEGIN
declare @StrA nvarchar(max)
declare @StrB nvarchar(max)
declare @TmpA nvarchar(max)
declare @TmpB nvarchar(max) --此區塊就可以處理商業邏輯，譬如利用tableA的ID將資料塞入tableB
select @StrA =(
		select top 1 MemberID
		from [dbo].[WS02_OS_RoleSetting]
		where AutoCounter = @AutoCounter
	)
select @TmpA =(
		select (
				select AccountName
				from [dbo].[EFC_CurrentMember]
				where AccountID = Replace(Data, '^', '')
			) + ','
		from [dbo].[SplitString](@StrA, ',') for xml path('')
	)
select @TmpB =(
		select (
				select AccountID
				from [dbo].[EFC_CurrentMember]
				where AccountID = Replace(Data, '^', '')
			) + '@' + (
				select DeptID
				from [dbo].[EFC_CurrentMember]
				where AccountID = Replace(Data, '^', '')
			) + ','
		from [dbo].[SplitString](@StrA, ',') for xml path('')
	)
update WS02_OS_RoleSetting
SET MemberName = [dbo].[fn_RemoveLastChar](@TmpA),
	MemberSavedValue = [dbo].[fn_RemoveLastChar](@TmpB)
where AutoCounter = @AutoCounter Fetch NEXT
FROM MyCursor INTO @AutoCounter
END --開始迴圈跑Cursor End
--關閉&釋放cursor
CLOSE MyCursor DEALLOCATE MyCursor
GO


DECLARE MyCursor CURSOR FOR
select UniqueID
from [dbo].WS02_sys_TemplateDATA
where len (SpecifyID) > 1
 Open MyCursor --�w�qID�ܼ�
declare @UniqueID nvarchar(500) --�ΨӦs��ID���ܼ�
	--�}�l�j��]Cursor Start
	Fetch NEXT
FROM MyCursor INTO @UniqueID While (@@FETCH_STATUS <> -1) BEGIN
declare @StrA nvarchar(max)
declare @StrB nvarchar(max)
declare @TmpA nvarchar(max)
declare @TmpB nvarchar(max) --���϶��N�i�H�B�z�ӷ~�޿�AĴ�p�Q��tableA��ID�N��ƶ�JtableB
select @StrA =(
		select top 1 SpecifyID
		from [dbo].WS02_sys_TemplateDATA
		where UniqueID = @UniqueID
	) --select  @StrA
select @TmpA =(
		select ---orginal value
			--+'['
			--+( substring(Data,CHARINDEX('[',   Data)+1,    CHARINDEX ( '@' , Data )-CHARINDEX('[', Data)-1 )
			(
				select AccountName
				from [dbo].[EFC_CurrentMember]
				where AccountID = Replace(Data, '^', '')
			) + ','
		from [dbo].[SplitString](@StrA, ',') for xml path('')
	)
select @TmpB =(
		select (
				select AccountID
				from [dbo].[EFC_CurrentMember]
				where AccountID = Replace(Data, '^', '')
			) + '@' + (
				select AccountName
				from [dbo].[EFC_CurrentMember]
				where AccountID = Replace(Data, '^', '') --)
			) + ','
		from [dbo].[SplitString](@StrA, ',') for xml path('')
	)
update WS02_sys_TemplateDATA
SET SpecifyName = [dbo].[fn_RemoveLastChar](@TmpA),
	SpecifySavedValue = [dbo].[fn_RemoveLastChar](@TmpB)
where UniqueID = @UniqueID Fetch NEXT
FROM MyCursor INTO @UniqueID
END --�}�l�j��]Cursor End
--����&����cursor
CLOSE MyCursor DEALLOCATE MyCursor
GO


DECLARE MyCursor CURSOR FOR
select UniqueID
from [dbo].WS02_sys_TemplateDATA
where len (SpecifyID_sub) > 1 Open MyCursor --�w�qID�ܼ�
declare @UniqueID nvarchar(500) --�ΨӦs��ID���ܼ�
	--�}�l�j��]Cursor Start
	Fetch NEXT
FROM MyCursor INTO @UniqueID While (@@FETCH_STATUS <> -1) BEGIN
declare @StrA nvarchar(max)
declare @StrB nvarchar(max)
declare @TmpA nvarchar(max)
declare @TmpB nvarchar(max) --���϶��N�i�H�B�z�ӷ~�޿�AĴ�p�Q��tableA��ID�N��ƶ�JtableB
select @StrA =(
		select top 1 SpecifyID_sub
		from [dbo].WS02_sys_TemplateDATA
		where UniqueID = @UniqueID
	) --select  @StrA
select @TmpA =(
		select (
				select AccountName
				from [dbo].[EFC_CurrentMember]
				where AccountID = Replace(Data, '^', '') --)
			) + ','
		from [dbo].[SplitString](@StrA, ',') for xml path('')
	)
select @TmpB =(
		select (
				select AccountID
				from [dbo].[EFC_CurrentMember]
				where AccountID = Replace(Data, '^', '')
			) + '@' + (
				select AccountName
				from [dbo].[EFC_CurrentMember]
				where AccountID = Replace(Data, '^', '')
			) + ','
		from [dbo].[SplitString](@StrA, ',') for xml path('')
	)
update WS02_sys_TemplateDATA
SET SpecifyName_sub = [dbo].[fn_RemoveLastChar](@TmpA),
	SpecifySavedValue_sub = [dbo].[fn_RemoveLastChar](@TmpB)
where UniqueID = @UniqueID Fetch NEXT
FROM MyCursor INTO @UniqueID
END --�}�l�j��]Cursor End
--����&����cursor
CLOSE MyCursor DEALLOCATE MyCursor
GO


