package com.example.SpringBoot_1.Dto;

import com.example.SpringBoot_1.entity.Article;
import lombok.AllArgsConstructor;
import lombok.ToString;

//lombok => overriding , getter , setter , toString() 를 대신 해줌 ==> refactoring 으로 코드 간결화
@AllArgsConstructor
@ToString
public class authorizedDto
{
    private String userid;
    private String userpassword;

 /*   public authorizedDto(String userid , String userpassword)
    {
        this.userid = userid;
        this.userpassword = userpassword;
    }

    @Override
    public String toString() {
        return "authorizedDto{" +
                "userid='" + userid + '\'' +
                ", userpassword='" + userpassword + '\'' +
                '}';
    }*/

    //dto 를 entity 로 변환
    public Article toEntity()
    {
        return new Article(null, userid , userpassword);
    }
}
