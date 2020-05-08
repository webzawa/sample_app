# class User
#   attr_accessor :name,:email

#   def initialize(attributes = {})
#     @name  = attributes[:name]
#     @email = attributes[:email]
#   end

#   def formatted_email
#     "#{@name} <#{@email}>"
#   end

# end



#演習
# class User
#   attr_accessor :firname,:lasname,:email

#   def initialize(attributes = {})
#     @firname  = attributes[:firname]
#     @lasname  = attributes[:lasname]
#     @email = attributes[:email]
#   end

#   def full_name
#     @fullname = "#{@firname} #{@lasname}"
#   end

#   def formatted_email
#     full_name
#     "#{@fullname} <#{@email}>"
#   end

# end