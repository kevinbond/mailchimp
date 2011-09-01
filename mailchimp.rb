require 'uri'
require 'net/http'
require 'json'

message = $currentCall.initialText
caller_id = $currentCall.callerID

API_KEY = 'mailchimp's API_KEY'

id =Net::HTTP.get_response(URI.parse("http://us2.api.mailchimp.com/1.3/?method=listsForEmail&apikey=#{API_KEY}&email_address=kbond@voxeo.com"))
list_id = JSON.parse(id.body)

subject = URI.encode("You just recieved a text message!")
message = URI.encode("#{message}")

email = "kbond@voxeo.com"
from = URI.encode("#{caller_id}")
to = URI.encode("Kevin Bond")

content = "[text]=#{message}"
options = "&options[list_id]=#{list_id[0]}&options[subject]=#{subject}&options[from_email]=#{email}&options[from_name]=#{from}&options[to_name]=#{to}"
parameters = "apikey=#{API_KEY}&type=plaintext&options=#{options}&content#{content}"

id = Net::HTTP.get_response(URI.parse("http://us2.api.mailchimp.com/1.3/?method=campaignCreate&#{parameters}"))
cid = id.body[1..10]

url = URI.parse("http://us2.api.mailchimp.com/1.3/?method=campaignSendNow&apikey=#{API_KEY}&cid=#{cid}")
req = Net::HTTP::Post.new("http://us2.api.mailchimp.com/1.3/?method=campaignSendNow&apikey=#{API_KEY}&cid=#{cid}")
res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }



