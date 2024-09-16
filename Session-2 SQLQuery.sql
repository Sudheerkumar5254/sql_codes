
use TEST_SQL;


select * from med_australia;
--1.GET THE NUMBER OF RECORDS IN THE TABLE
select count(*) No_of_Records from med_australia;

--2.GET THE NUMBER OF COLUMNS IN THE TABLE
select count(* ) no_of_columns from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='med_australia';

--3.GER THE DISTINCT VALUES OF STATE_CODE
select distinct(state_code) from med_australia;

--4.GET COUNT OF DISTINCT VALUES OF COMPANY,STATE_CODE AND GENDER FIELDS TOGETHER
select count (distinct CONCAT (company,state_code,gender)) as Distinct_count from med_australia;

--5.SELECT TOP 100 RECORDS FROM THE TABLE
select top 100 * from med_australia;

--6.GET THE COUNT OF NULL VALUES IN THE COLUMN CONTACT_PREF

select count(*) from med_australia where contact_pref is null;


select * from med_australia;
--7.SELECT TOP 70% OF RECORDS FROM THE TABLE
select top 70 percent * from med_australia;

--8.DESCRIBE THE TABLE BY NUMBER OF COLUMNS AND FIELD DATA TYPES
select * from INFORMATION_SCHEMA.columns where TABLE_NAME='med_australia';

--9.SELECT 1000 RANDOM RECORDS FROM THE TABLE
select top 1000 * from med_australia order by newid(); 


--Q3
select CUSTOMER_ID as sub_id,
COMPANY as business_house,
GENDER,
AGE,
STATE_CODE as province,
TOWN,
NO_OF_TRIPS,
SPENT_AMOUNT as spent,
card_reg_date
into med_select_v1
from med_australia;

select * from med_australia;
select * from med_select_v1;

--Q4.
select *
into med_select_v3
from med_select_v1
WHERE BUSINESS_HOUSE IN ('APPOLO','GENO','RELGARE') and 
GENDER IN ('FEMALE', 'MALE') and
province IN ('ACT','NSW','WA','QLD') and
SPENT>= 50 and
CARD_REG_DATE between '12-01-2006' and '12-31-2007';

select * from med_select_v1;
--Q5
select * into med_select_v4 from med_select_v1
where town like 'b%' and gender='female' and age between 30 and 70;
select * from med_select_v4;

--Q6

select 
*
into med_select_v5
from med_select_v1
order by province,business_house,GENDER,spent desc;	
select * from med_select_v1;
select * from med_select_v5;

--Task-3
--Q1
select * from med_select_v62;
select * from med_select_v6(ref);
select * from new_table;

select * into med_select_v62 from (select customer_id,company,card_reg_date,gender,age,
case 
when age > 70 then 'old-age' 
when age >50 then 'mid-old-age'
when age >=30 then 'mid-young-age'
else 'young-age'
end as 'age-bucket',
rgstn_type_ind,state_code,no_of_trips,town,contact_pref,spent_amount,
case
when spent_amount >1000 then 'luxury'
when spent_amount >700 then 'modern'
when spent_amount >500 then 'medium'
when spent_amount >300 then 'casual'
else 'poor' 
end as 'spent_bucket',
case
when age between 30 and 70 and gender='female' and spent_amount >=300 then 'premier'
when age between 30 and 70 and gender='male' and spent_amount >=300 then 'premier'
else 'non-premier'
end as 'customer_segment'
from med_select_v6) as new_table;

select * from med_select_v6;
--Q2
select 
format(count(customer_id),'n0') as Subs,
format(sum(no_of_trips),'n0') as visits,
format(sum(Spent_amount),'c0') as total_spent
from med_select_v6;
--Q3
select 
coalesce(company,'grand_total') as company,
format(count(customer_id),'n0') as subs,
format(sum(no_of_trips),'n0') as visits,
format(sum(spent_amount),'c0') as Total_spent
from med_select_v6
group by rollup (company)
order by company;
--Q4

select company,gender,
format(count(customer_id),'n0') as subs,
format(sum(no_of_trips),'n0') as visits,
format(sum(spent_amount),'c0') as Total_spent
from med_select_v6
group by company,gender
order by company, gender;

--Q5
--GET STATE_CODE (QLD AND VIC) AND COMPANY WISE SUM OF SPENT_AMOUNT >= 20000
select state_code,company,
format(sum(spent_amount),'c0') as total_spent
from med_select_v6
where state_code in('qld','vic')  
group by state_code, company
having sum(spent_amount)>=20000
order by state_code, company;

--Q6
select * from med_select_v6;

--Q7

/*FROM TABLE MED_SELECT_V6 GET THE SUMMARY OUTPUT BY	
BY COMPANY	
BY GENDER	
BY CUSTOMER_SEGMENT	
BY AGE_BUCKET	
COUNT OF CUSTOMER_ID	FORMAT IN  NUMBERS
SUM OF TRIPS	FORMAT IN  NUMBERS
SUM OF SPENT	FORMAT IN  CURRENCY*/
select * from med_select_v6
select company,gender,customer_segment,age_bucket, 
format(count(customer_id),'n0') as count_of_cstid,
format(sum(no_of_trips),'n0') as Sum_of_trips,
format(sum(spent_amount),'c0') as Sum_of_spent from med_select_v6
group by company,gender,customer_segment,age_bucket
order by 1,2,3,4;

--Q8
select count(*) from med_select_v6 where contact_pref is null;

--Task-4
--Q1
--FROM CUSTOMER_MONTHLY_SALES TABLE GET Q1+Q2+Q3+Q4 AS TOTAL SALES

 select customer_id,company, jan+feb+mar as Q1,
apr+may+jun as Q2,
jul+aug+sep as Q3,
oct+nov+dec as Q4
 from customer_monthly_sales;

 
 select customer_id,company, jan+feb+mar as Q1,
apr+may+jun as Q2,
jul+aug+sep as Q3,
oct+nov+dec as Q4 
into customer_yearly_sales
from Customer_monthly_sales;

 select customer_id,company, q1,q2,q3,q4,
 Q1+Q2+Q3+Q4 as Total_sales from customer_yearly_sales; 

 --Q2 Ans qurterly sales in percentage 

 select
 format((q1/(q1+q2+q3+q4)),'p2') as Q1_sale_percent,
 format((q2/(q1+q2+q3+q4)),'p2') as Q2_sale_percent,
 format((q3/(q1+q2+q3+q4)),'p2') as Q3_sale_percent,
 format((q4/(q1+q2+q3+q4)),'p2') as Q4_sale_percent 
 from customer_yearly_sales;


 --Task-6
 --Q1
 select * from stu_course;

 alter table stu_course
 drop column environment;

 select * from stu_course;

 select
 full_name,city,
 state,phone,course,tool,fee,
 date_of_joining,
 case when date_of_joining >'03-01-2020' then 'Pandamic'
 else 'Normal' end as Environment
  FROM STU_COURSE;

 SELECT * INTO STU_COURSE_1 FROM (select
 full_name,city,
 state,phone,course,tool,fee,
 date_of_joining,
 case when date_of_joining >'03-01-2020' then 'Pandamic'
 else 'Normal' end as Environment
  FROM STU_COURSE) AS X;

  
  --Q2 
  
 select *,
case 
    when ENVIRONMENT='pandamic' and course='mpids' then
case 
	when tool='SAS ' AND FEE= '25000' THEN FEE*0.2
	WHEN TOOL='POWER BI' AND FEE= '19000' THEN FEE*0.3
	WHEN TOOL='ADVANCED ANALYTICS' AND FEE= '45000' THEN FEE*0.1
	WHEN TOOL='MACHINE LEARNING' AND FEE= '75000' THEN FEE*0.2
	ELSE 0
END
    WHEN ENVIRONMENT='PANDAMIC' AND COURSE= 'ADA' THEN
CASE 
    WHEN TOOL='SQL ' AND FEE= '15000' THEN FEE*0.1
	WHEN TOOL='PYTHON' AND FEE= '15000' THEN FEE*0.1
	WHEN TOOL='SAS' AND FEE= '25000' THEN FEE*0.2
	WHEN TOOL='R' AND FEE= '15000' THEN FEE*0.1
	WHEN TOOL='ADVANCED ANALYTICS' AND FEE= '45000' THEN FEE*0.1
	ELSE 0
END
	WHEN ENVIRONMENT='PANDAMIC' AND COURSE='DAS' THEN
CASE
    WHEN TOOL='SAS' AND FEE= '25000' THEN FEE*0.2
	ELSE 0
END
     WHEN ENVIRONMENT='PANDAMIC' AND COURSE='MINI MODULE' THEN
CASE 
     WHEN TOOL='TABLEAU'AND FEE='17000' THEN FEE*0.1
	 WHEN TOOL='POWER BI'AND FEE='19000' THEN FEE*0.1
	 ELSE 0
END
ELSE 0
	 END AS DISCOUNT FROM STU_COURSE_1;
	---------------------------------------------------------
	
select * into stu_course_2 from(	Select *,
case 
    when ENVIRONMENT='pandamic' and course='mpids' then
case 
	when tool='SAS ' AND FEE= '25000' THEN FEE*0.2
	WHEN TOOL='POWER BI' AND FEE= '19000' THEN FEE*0.3
	WHEN TOOL='ADVANCED ANALYTICS' AND FEE= '45000' THEN FEE*0.1
	WHEN TOOL='MACHINE LEARNING' AND FEE= '75000' THEN FEE*0.2
	ELSE 0
END
    WHEN ENVIRONMENT='PANDAMIC' AND COURSE= 'ADA' THEN
CASE 
    WHEN TOOL='SQL ' AND FEE= '15000' THEN FEE*0.1
	WHEN TOOL='PYTHON' AND FEE= '15000' THEN FEE*0.1
	WHEN TOOL='SAS' AND FEE= '25000' THEN FEE*0.2
	WHEN TOOL='R' AND FEE= '15000' THEN FEE*0.1
	WHEN TOOL='ADVANCED ANALYTICS' AND FEE= '45000' THEN FEE*0.1
	ELSE 0
END
	WHEN ENVIRONMENT='PANDAMIC' AND COURSE='DAS' THEN
CASE
    WHEN TOOL='SAS' AND FEE= '25000' THEN FEE*0.2
	ELSE 0
END
     WHEN ENVIRONMENT='PANDAMIC' AND COURSE='MINI MODULE' THEN
CASE 
     WHEN TOOL='TABLEAU'AND FEE='17000' THEN FEE*0.1
	 WHEN TOOL='POWER BI'AND FEE='19000' THEN FEE*0.1
	 ELSE 0
END
ELSE 0
	 END AS DISCOUNT 
	 	 FROM STU_COURSE_1) as D;
	-------
	 
	 ---Q3

	 	select * into stu_course_v3 from (select *,(fee-discount) as new_fee 
		from stu_course_2) as V;
		
		Select * from stu_course_v3;
		
	
	 --Task-7
	 --Q1
	 select customer_id,company,month,sales
	 into transpose_month_1
	 from transpose_month
	 unpivot(sales for month in(jan,feb,mar,apr,may,jun,jul,aug,sep,oct,nov,dec)) as X;

	 select customer_id,company,jan,feb,mar,apr,may,jun,jul,aug,sep,oct,nov,dec
	  from transpose_month_1
	 pivot(sum(sales) for month in(jan,feb,mar,apr,may,jun,jul,aug,sep,oct,nov,dec)) as X;
	  
		select * from  transpose_month;
		select * from transpose_month_1;

--Q2
		select * from transpose_year;

	select customer_id,company,year,sales
	into transpose_year_1
	from transpose_year
	unpivot(sales for year in(2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020)) as xyz;

	select customer_id,company,
	2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020 from transpose_year_1
	pivot(sum(sales) for year in (2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020)) as V;

		SELECT * FROM pivot_info;













