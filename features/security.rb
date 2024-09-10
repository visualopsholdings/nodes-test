
When('there is default security') do

   step "there are users:", table(%{
         | name      | admin  | fullname  | id                       |
         | tracy     | true   | Tracy     | 6121bdfaec9e5a059715739c |
         | leanne    | false  | Leanne    | 6142d258ddf5aa5644057d35 |
         | alice     | false  | Alice     | |
         | bob       | false  | Bob       | |
         | chuck     | false  | Chuck     | |
   })
   
   step "there are groups:", table(%{
         | name        | id                        |
         | Team 1      | 61a58472ddf5aa463a08293d  |
         | Public      | 61a58472ddf5aa463a08293e  |
   })
         
   step "there are users in group \"Team 1\":", table(%{
         | name      | roles           |
         | tracy     | admin user      |
         | leanne    | pleb user       |
         | chuck     |                 |
   })
         
   step "there are users in group \"Public\":", table(%{
         | name      | roles          |
         | tracy     |                |
         | leanne    |                |
         | alice     |                |
         | bob       |                |
         | chuck     |                |
   })

   step "there are policies:", table(%{
         | name   | viewuser           | viewgroup | edituser           | editgroup | execuser           | execgroup |
         | p1     |                    | Team 1    |                    | Team 1    |                    | Team 1    |
         | p2     |                    | Public    |                    | Public    |                    | Public    |
         | p3     | tracy leanne alice |           | tracy leanne alice |           | tracy leanne alice |           |
         | p4     | alice              | Team 1    | alice              | Team 1    |                    |           |
   })
         
   step "the security indexes are generated"

   step "groups have policies:", table(%{
         | name         | policy |
         | Team 1       | p1     |
         | Public       | p2     |
   })
         
end

