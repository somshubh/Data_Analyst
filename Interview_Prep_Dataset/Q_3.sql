CREATE TABLE ordersd (
    order_id INT PRIMARY KEY,
    item VARCHAR(255) NOT NULL
);

INSERT INTO ordersd (order_id, item) VALUES
(1, 'Chow Mein'),
(2, 'Pizza'),
(3, 'Veg Nuggets'),
(4, 'Paneer Butter Masala'),
(5, 'Spring Rolls'),
(6, 'Veg Burger'),
(7, 'Paneer Tikka');

with cte as(
 select*,  
  case when order_id % 2 <> 0 then lead(item, 1, item)over(order by order_id)
       when order_id % 2 = 0 then Lag(item, 1, item)over(order by order_id) end as new_id
from ordersd
)
select * from cte;

approach 2:

with cte as(
 select*,  
  case 
       when order_id % 2 = 0 then order_id - 1 else order_id +1 end as new_id
from ordersd
)
select o.order_id, o.item, coalesce(c1.item, o.item) swap_item from ordersd o left join cte c1 on o.order_id = c1.new_id