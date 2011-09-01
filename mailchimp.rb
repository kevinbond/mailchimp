require 'uri'
require 'net/http'
require 'json'

message = $currentCall.initialText
callerID = $currentCall.callerID

apiKey = '1a4d654d423a919183d00f8afdb8a558-us2'

id =Net::HTTP.get_response(URI.parse("http://us2.api.mailchimp.com/1.3/?method=listsForEmail&apikey=1a4d654d423a919183d00f8afdb8a558-us2&email_address=kbond@voxeo.com"))
listID = JSON.parse(id.body)

subject = URI.encode("You just recieved a text message!")
message = URI.encode("#{message}")

email = "kbond@voxeo.com"
from = URI.encode("#{callerID}")
to = URI.encode("Kevin Bond")

content = "[text]=#{message}"
options = "&options[list_id]=#{listID[0]}&options[subject]=#{subject}&options[from_email]=#{email}&options[from_name]=#{from}&options[to_name]=#{to}"
parameters = "apikey=#{apiKey}&type=plaintext&options=#{options}&content#{content}"

id = Net::HTTP.get_response(URI.parse("http://us2.api.mailchimp.com/1.3/?method=campaignCreate&#{parameters}"))
cid = id.body[1..10]

url = URI.parse("http://us2.api.mailchimp.com/1.3/?method=campaignSendNow&apikey=#{apiKey}&cid=#{cid}")
req = Net::HTTP::Post.new("http://us2.api.mailchimp.com/1.3/?method=campaignSendNow&apikey=#{apiKey}&cid=#{cid}")
res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }



