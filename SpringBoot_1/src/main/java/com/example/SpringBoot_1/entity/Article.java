package com.example.SpringBoot_1.entity;

import lombok.AllArgsConstructor;
import lombok.ToString;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;




public class Article
{
    @Id// 대표값을 지정 (식별하기위함)
    @GeneratedValue //=> 1...2..3... 자동생성 해주는 에노테이션
    //대표값
    private Long id;
    @Column
    private String userid;
    @Column
    private String userpassword;

    public Article(Long id , String userid , String userpassword)
    {
    this.id = id;
    this.userid = userid;
    this.userpassword = userpassword;


    }


    @Override
    public String toString() {
        return "Article{" +
                "id=" + id +
                ", userid='" + userid + '\'' +
                ", userpassword='" + userpassword + '\'' +
                '}';
    }
}
