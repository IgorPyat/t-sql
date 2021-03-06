USE [Test]
GO
/****** Object:  UserDefinedFunction [dbo].[Anuitet]    Script Date: 20.03.2019 23:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER FUNCTION [dbo].[Anuitet] (@crenum varchar(40),@sumcre float, @crestart datetime, @creend datetime, @intrate float)
RETURNS @result TABLE (AccountNumber varchar, PayDay datetime, PaySum float,CreOst float)
AS
Begin
	declare @term float
	declare @acoef float
	declare @coef float
	declare @a int
	declare @paysum float
	declare @payday datetime
	set @term = (select DATEDIFF(month,@crestart,@creend))
	set @acoef = (@intrate/1200)
	set @coef = (@acoef*(select power((1+@acoef),@term)))/(select power((1+@acoef),@term)-1)
	set @paysum = @coef*@sumcre
	set @a = 0
	while @crestart != @creend
	begin
		set @payday = (select convert(date,(select dateadd(month, @a,@crestart))))
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

