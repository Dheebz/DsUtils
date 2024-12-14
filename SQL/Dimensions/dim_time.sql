declare @time_start time = '00:00:00';
declare @time_end time = '23:59:59';
declare @time_interval int = 1;

-- Declare the table variable
declare @tbl table (
    time_key int,
    time_value time,
    hour_int int,
    hour_time time,
    minute_int int,
    minute_time time,
    second_int int
);

-- Loop through the time range
while @time_start <= @time_end
begin
    insert into @tbl
    select
        time_key = cast(replace(convert(varchar(8), @time_start, 108), ':', '') as int),
        time_value = @time_start,
        hour_int = datepart(hour, @time_start),
        hour_time = cast(dateadd(hour, datediff(hour, 0, @time_start), 0) as time),
        minute_int = datepart(minute, @time_start),
        minute_time = cast(dateadd(minute, datediff(minute, 0, @time_start), 0) as time),
        second_int = datepart(second, @time_start)

    set @time_start = dateadd(second, @time_interval, @time_start);
end;

-- Select the generated data
select * from @tbl;

