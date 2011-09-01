%w(uri net/http json).each{|lib| require lib}

#CONFIG
YOUR_NAME = "Kevin Bond"
API_URL = "http://us2.api.mailchimp.com/1.3"
API_KEY = 'mailchimp_api_key'
FROM_ADDRESS = "kbond@voxeo.com"

# Get the initial Text, and callerId
initial_text = $currentCall.initialText
caller_id = $currentCall.callerID

#Encode user data for API request
to = URI.encode(YOUR_NAME)

id =Net::HTTP.get_response(URI.parse("#{API_URL}/?method=listsForEmail&apikey=#{API_KEY}&email_address=#{FROM_ADDRESS}"))
listID = JSON.parse(id.body)

subject = URI.encode "You just recieved a text message!"

content = "[text]=#{URI.encode(initial_text)}"
options = "&
options[list_id]=#{listID[0]}&
options[subject]=#{subject}&
options[from_email]=#{FROM_ADDRESS}&
options[from_name]=#{URI.encode(caller_id)}&
options[to_name]=#{to}".gsub("\n","")
        
        
parameters = "apikey=#{API_KEY}&type=plaintext&options=#{options}&content#{content}"

id = Net::HTTP.get_response(URI.parse("#{API_URL}/?method=campaignCreate&#{parameters}"))
cid = id.body[1..10]

url = URI.parse("#{API_URL}/?method=campaignSendNow&apikey=#{API_KEY}&cid=#{cid}")
req = Net::HTTP::Post.new("#{API_URL}/?method=campaignSendNow&apikey=#{API_KEY}&cid=#{cid}")
res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }


