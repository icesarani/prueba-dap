Select u.CustomerName, u.Email,
(Select sum(Quantity * UnitPrice)
from Orders o
where estado = 'Completed' and O.user_id = U.user_id
)
from users U
