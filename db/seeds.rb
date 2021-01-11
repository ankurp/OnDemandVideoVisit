User.create(email: "admin@domain.com", password: "P@ssw0rd", user_role: :admin).confirm
User.create(email: "ankur@domain.com", password: "P@ssw0rd").confirm
User.create(email: "provider@domain.com", password: "P@ssw0rd", user_role: :provider).confirm
