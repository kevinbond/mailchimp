%w(uri net/http json).each{|lib| require lib}

#CONFIG
YOUR_NAME = URI.encode("your_name")
API_URL = "http://us2.api.mailchimp.com/1.3"
API_KEY = 'mailchimp_api_key'
FROM_ADDRESS = "primary_email"
SUBJECT = URI.encode("You just recieved a text message!")

# Get the initial Text, and callerId
initial_text = $currentCall.initialText
caller_id = $currentCall.callerID

#Get the list ID that corresponds to your email
id =Net::HTTP.get_response(URI.parse("#{API_URL}/?method=listsForEmail&apikey=#{API_KEY}&email_address=#{FROM_ADDRESS}"))
list_id = JSON.parse(id.body)

#This will be the body of your email, which is the text message
content = "[text]=#{URI.encode(initial_text)}"

#Setting the url variables
options = "&
options[list_id]=#{list_id[0]}&
options[subject]=#{SUBJECT}&
options[from_email]=#{FROM_ADDRESS}&
options[from_name]=#{URI.encode(caller_id)}&
options[to_name]=#{YOUR_NAME}".gsub("\n","")
        
#Parameters will be the variable that goes inside of the url
#To satisfy mailchimps method, you need 4 fields, the apikey, type of email, 
#options - which is an array or hash, and content - which is also an array or hash
parameters = "apikey=#{API_KEY}&type=plaintext&options=#{options}&content#{content}"

#This responses creates a new campaign and returns the id for that campaign
id = Net::HTTP.get_response(URI.parse("#{API_URL}/?method=campaignCreate&#{parameters}"))
cid = id.body[1..10]

#This is a post to send the email using the cid, which is the campaign id
url = URI.parse("#{API_URL}/?method=campaignSendNow&apikey=#{API_KEY}&cid=#{cid}")
req = Net::HTTP::Post.new("#{API_URL}/?method=campaignSendNow&apikey=#{API_KEY}&cid=#{cid}")
res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }


