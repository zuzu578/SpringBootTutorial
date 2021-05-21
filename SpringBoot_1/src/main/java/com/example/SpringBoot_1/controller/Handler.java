package com.example.SpringBoot_1.controller;
import com.example.SpringBoot_1.Dto.authorizedDto;
import com.example.SpringBoot_1.entity.Article;
import com.example.SpringBoot_1.repository.ArticleRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import javax.servlet.http.HttpServletRequest;

//Controller
@Controller
//SLf4j => 로깅을 위한 에노테이션
@Slf4j
public class Handler
{
    //객체주입 (DI) => spring boot가 미리 생성해놓은 객체를 가져다가 auto wired 해줌
    @Autowired
    private ArticleRepository articleRepository;
    //Model
    @GetMapping("/Home")
    public String Home(Model model)
    {
        model.addAttribute("username","dlwnghks6821");
        return "Home";
    }

    @GetMapping("/Next")
    public String Next(Model model)
    {
        model.addAttribute("words","NextPage");
        return "Next";

    }
    @GetMapping("/MyForm")
    public String MyForm(HttpServletRequest httpServletRequest)
    {

        return "MyForm";
    }
    // => form 에서 post 방식으로 parameter 전달시 post 전달 => @PostMapping
    // => form 에서 get 방식으로 parameter 전달시 get 전달 => @GetMapping
    @PostMapping("/authorized")
    public String authorized(authorizedDto dto , Model model)
    {

        System.out.println(dto.toString());
        //loging
        model.addAttribute("dto",dto);
        //jpa 로 db저장
        //1) dto 를 Entity 로 변환 => Article , toEntity()
        Article article = dto.toEntity();

        //2) Repository 에게 Entity를 DB안에 저장
        System.out.println(article.toString());
        Article saved  = articleRepository.save(article);
        System.out.println(saved.toString());
        return "authorized";

    }
}
