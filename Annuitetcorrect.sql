-- ================================================
-- Template generated from Template Explorer using:
-- Create Multi-Statement Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION Anuitet (@crenum varchar,@sumcre float, @crestart datetimeoffset, @creend datetimeoffset, @intrate float)
RETURNS @result TABLE (AccountNumber varchar, PayDay datetimeoffset, PaySum float,CreOst float)
AS
Begin
	declare @term float
	declare @acoef float
	declare @coef float
	declare @a int
	declare @paysum float
	declare @payday datetimeoffset
	set @term = (select DATEDIFF(month,@crestart,@creend))
	set @acoef = (@intrate/1200)
	set @coef = (@acoef*(select power((1+@acoef),@term)))/(select power((1+@acoef),@term)-1)
	set @paysum = @coef*@sumcre
	set @a = 0
	while @crestart != @creend
	begin
		set @payday = (select dateadd(month, @a,@crestart))
		set @a = @a+1
		if @crestart < @creend
		begin
			insert into @result values (@crenum,@payday,@paysum,@sumcre-@paysum)
		end
		else
		begin
			insert into @result values (@crenum,@creend,@paysum,@sumcre-@paysum)
		end
		set @sumcre = @sumcre-@paysum
	end
RETURN 
END
GO