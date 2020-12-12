if Rails.env.development? || Rails.env.test?
  user = User.create(
    first_name: "First",
    last_name: "Last",
    email: "user@email.com",
    password: "123456"
  )

  user.confirm
  user.add_role :admin
end
