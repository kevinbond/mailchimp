%w(uri net/http json).each{|lib| require lib}

<<<<<<< HEAD
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
=======
message = $currentCall.initialText
caller_id = $currentCall.callerID

API_KEY = 'mailchimp's API_KEY'

id =Net::HTTP.get_response(URI.parse("http://us2.api.mailchimp.com/1.3/?method=listsForEmail&apikey=#{API_KEY}&email_address=kbond@voxeo.com"))
list_id = JSON.parse(id.body)
>>>>>>> ea4e19099f718716f2d6452c697874d39114698f

id =Net::HTTP.get_response(URI.parse("#{API_URL}/?method=listsForEmail&apikey=#{API_KEY}&email_address=#{FROM_ADDRESS}"))
listID = JSON.parse(id.body)

<<<<<<< HEAD
subject = URI.encode "You just recieved a text message!"

content = "[text]=#{URI.encode(initial_text)}"
options = "&options[list_id]=#{listID[0]}&options[subject]=#{subject}&options[from_email]=#{FROM_ADDRESS}&options[from_name]=#{URI.encode(caller_id)}&options[to_name]=#{to}"
=======
email = "kbond@voxeo.com"
from = URI.encode("#{caller_id}")
to = URI.encode("Kevin Bond")

content = "[text]=#{message}"
options = "&options[list_id]=#{list_id[0]}&options[subject]=#{subject}&options[from_email]=#{email}&options[from_name]=#{from}&options[to_name]=#{to}"
>>>>>>> ea4e19099f718716f2d6452c697874d39114698f
parameters = "apikey=#{API_KEY}&type=plaintext&options=#{options}&content#{content}"

id = Net::HTTP.get_response(URI.parse("#{API_URL}/?method=campaignCreate&#{parameters}"))
cid = id.body[1..10]

<<<<<<< HEAD
url = URI.parse("#{API_URL}/?method=campaignSendNow&apikey=#{API_KEY}&cid=#{cid}")
req = Net::HTTP::Post.new("#{API_URL}/?method=campaignSendNow&apikey=#{API_KEY}&cid=#{cid}")
=======
url = URI.parse("http://us2.api.mailchimp.com/1.3/?method=campaignSendNow&apikey=#{API_KEY}&cid=#{cid}")
req = Net::HTTP::Post.new("http://us2.api.mailchimp.com/1.3/?method=campaignSendNow&apikey=#{API_KEY}&cid=#{cid}")
>>>>>>> ea4e19099f718716f2d6452c697874d39114698f
res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }



