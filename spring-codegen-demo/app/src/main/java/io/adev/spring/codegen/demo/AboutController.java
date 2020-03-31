package io.adev.spring.codegen.demo;

import client.About;
import client.DefaultApi;
import com.fasterxml.jackson.core.JsonFactory;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@RestController("/")
public class AboutController {

    private DefaultApi api = new DefaultApi(JsonFactory.builder().build());

    private About about = new About(
            "title2",
            "text1"
    );

    @DefaultApi.GetAbout.Mapping
    public void get(HttpServletRequest request, HttpServletResponse response) throws IOException {
        api.getAbout.respondOk(
                about,
                response
        );
    }

    @RequestMapping(method = RequestMethod.PUT, path = "/about")
    public void set(HttpServletRequest request, HttpServletResponse response) throws IOException {
        DefaultApi.SetAbout.Params params = api.setAbout.paramsFrom(request);
        about = params.getBody();
        api.setAbout.respondOk(response);
    }
}