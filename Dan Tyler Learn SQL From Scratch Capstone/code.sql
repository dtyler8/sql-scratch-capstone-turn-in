-- 1) How many campaigns and sources does CoolTShirts use?

Select Count(Distinct utm_campaign) as 'Campaigns'
From page_visits;

Select Count(Distinct utm_source) as 'Sources'
From page_visits;

Select Distinct utm_campaign as Campaigns,
	utm_source as Sources
From page_visits;

--2) What pages are on their website?

Select Distinct page_name as 'Page Names'
From page_visits;

--3) How many first touches is each campaign responsible for?

With first_touch as (
Select user_id, 
	Min(timestamp) as first_touch_at
From page_visits
Group By user_id),
ft_attr as (
Select ft.user_id,
	ft.first_touch_at,
	pv.utm_source,
	pv.utm_campaign
From first_touch ft
Join page_visits pv
	On ft.user_id = pv.user_id
	And ft.first_touch_at = pv.timestamp
)
Select ft_attr.utm_source as Source
	ft_attr.utm_campaign as Campaign,
	Count(*) as Count
From ft_attr
Group By 1, 2
Order By 3 desc;

--4) How many last touches is each campaign responsible for?

With last_touch as (
Select user_id, 
	Max(timestamp) as last_touch_at
From page_visits
Group By user_id),
lt_attr as (
Select lt.user_id,
	lt.last_touch_at,
	pv.utm_source,
	pv.utm_campaign
From last_touch lt
Join page_visits pv
	On lt.user_id = pv.user_id
	And lt.last_touch_at = pv.timestamp
)
Select lt_attr.utm_source as Source
	lt_attr.utm_campaign as Campaign,
	Count(*) as Count
From lt_attr
Group By 1, 2
Order By 3 desc;

--5) How many visitors make a purchase?

Select Count(Distinct user_id) as 'Visitors Who Purchase'
From page_visits
Where page_name = '4 - purchase';

--6) How many last touches on the purchase page is each campaign responsible for?

With last_touch as (
Select user_id, 
	Max(timestamp) as last_touch_at
From page_visits
Where page_name = '4 - purchase'
Group By user_id),
lt_attr as (
Select lt.user_id,
	lt.last_touch_at,
	pv.utm_source,
	pv.utm_campaign
From last_touch lt
Join page_visits pv
	On lt.user_id = pv.user_id
	And lt.last_touch_at = pv.timestamp
)
Select lt_attr.utm_source as Source
	lt_attr.utm_campaign as Campaign,
	Count(*) as Count
From lt_attr
Group By 1, 2
Order By 3 desc;