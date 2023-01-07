select *
from suicide

---delete unused column---
alter table suicide
drop column HDI_for_year

alter table suicide
drop column country_year

alter table suicide
drop column generation

alter table suicide
drop column suicides_100k_pop

---add new colunm for age demograph---
alter table suicide
add age_demograph varchar(50)

update suicide
set age_demograph = case
						when age = '5-14 years 'then 'children'
						when age = '15-24 years' then 'youth'
						when age = '25-34 years' then 'adult'
						when age = '35-54 years' then 'middle-aged adult'
						when age = '55-74 years' then 'late adulthood'
						else 'old'
						end

---Total countries involved---
select count(distinct(country)) as total_country
from suicide


---number of suicide per country---
select distinct(country), sum(suicides_no) as suicide_per_country
from suicide
group by country
order by suicide_per_country desc

---country suicide number per sex---
select distinct(country), sum(suicides_no) as male
from suicide
where sex = 'male' --and sex = 'female'
group by country


select distinct (country), sum(suicides_no) as female
from suicide
where sex = 'female'
group by country

---suicide per year---
select distinct(year), sum(suicides_no) as no_of_suicide_per_year
from suicide
group by year
order by year asc

---total number of suicide---
select sum(suicides_no) as total_number_of_suicide
from suicide

---suicide number per age demograph---
select distinct(age_demograph),sum(suicides_no) as suicide_number
from suicide
group by age_demograph

--------------------------------------------------------------
---Break things down to country---
--- using USA as a case study---

select *
from suicide
where country like '%state%'

----total sucide number in United state---

select country, sum(suicides_no) as suicides_no
from suicide
where country like '%states%'
group by country

--- suicide number per year in United State---
select distinct(year), sum(suicides_no) as US_suicide_no
from suicide
where country like '%states%'
group by year
order by year asc

---suicide number vs gdp per capita

--------create two temp tables---
create table #suicide_no(
year smallint,
suicides_no int)

insert into #suicide_no
select distinct (year), sum(suicides_no) as suicides_no
from suicide
where country like '%state%'
group by year

create table #gdp(
year smallint,
gdp_per_capita int)

insert into #gdp
select distinct (year), gdp_per_capita
from  suicide
where country like '%state%'

select *
from #suicide_no

select *
from #gdp

select #suicide_no.year, suicides_no, gdp_per_capita
from #suicide_no 
inner join #gdp
	on #suicide_no.year = #gdp.year


---suicide number per sex---
select distinct (sex), sum(suicides_no) as no_of_suicide_per_sex
from suicide
where country like '%state%'
group by sex


---suicide number vs population 

select distinct(year), sum(suicides_no) as total_suicide_no, sum(population) as total_population
from suicide
where country like '%states%'
group by year

---suicide number per age demograph---
select distinct(age_demograph),sum(suicides_no) as suicide_number
from suicide
where country like '%state%'
group by age_demograph

--select *
--from #suicide_number_vs_population

--select year, total_suicide_no, total_population, (total_suicide_no / total_population) --*100--/total_population * 100
--from #suicide_number_vs_population