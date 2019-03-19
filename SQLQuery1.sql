use Test
create table test 
(id int, datereportbuilt datetime, datecreditend datetime, payday datetime, paysum float) 

insert into test (id, datereportbuilt, datecreditend) values (3, (select getdate()), '20270307')

create table #temp (id int, payday datetimeoffset, datecreditend datetime, paysum float, dolg float)
declare @a int
declare @b datetimeoffset
declare @c int
declare @pd float
declare @plod float
declare @plp float
declare @pl float
set @a = 2
set @pd = 10000.00
while @a <= (select max(id) from test)
begin
	set @b = (select dateadd(month,@c,(getdate())))
	set @c = 0
	while @b != (select datecreditend from test where id=@a)
	begin
		set @plod =  (@pd*0.05)
		set @plp =(@pd*0.13)/12
		set @pl = @plod+@plp
		set @b = (select dateadd(month,@c,(getdate())))
		set @c = @c +1
		if @b < (select datecreditend from test where id=@a)
		begin
			insert into #temp values ((select id from test where id=@a), @b, (select datecreditend from test where id = @a), @pl, @pd)
		end
		else
		begin
			set @b = (select datecreditend from test where id = @a)
			insert into #temp values ((select id from test where id=@a), @b, (select datecreditend from test where id = @a), @pd+@plp, @pd)
		end
		set @pd = @pd-@plod
	end
	set @a = @a+1
end

select * from #temp
order by id, payday
drop table #temp
delete  from #temp 
where (select payday from #temp where id = 1) > (select datecreditend from #temp where id =1)