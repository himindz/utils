require 'ruby-jmeter'
test do
  header [
    { name: 'Content-Type', value: 'application/json' }
  ]
  threads count: 1, loops: 100, scheduler: false do
    get name: 'Get /user', url: 'http://localhost:5000/user'
  end
  
end.run( jtl: 'user_list.jtl')