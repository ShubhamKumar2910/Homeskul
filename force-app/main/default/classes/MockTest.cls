public class MockTest implements HttpCalloutMock{
    
    public HttpResponse respond(HttpRequest req){
        String body='{"reminder_enable":true,"notify":{"sms":true,"email":true},"notes":{"policy_name":"0060p00000BDeBuAAL"},"first_min_partial_amount":5000.00,"expire_by":1691097057,"description":"Payment for policy no #23456","customer":{"name":"Test","email":"dineshbaddawar@gmail.com","contact":"122234567890"},"currency":"INR","callback_url":"https://cms-assets.tutsplus.com/cdn-cgi/image/width=850/uploads/users/523/posts/32694/final_image/tutorial-preview-large.png","callback_method":"get","amount":5000.00,"accept_partial":true}';
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type','application/xml');
        res.setBody(body);
        res.setStatusCode(200);
        return res;
        
    }
}