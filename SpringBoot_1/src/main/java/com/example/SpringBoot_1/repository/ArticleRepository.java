package com.example.SpringBoot_1.repository;

import com.example.SpringBoot_1.entity.Article;
import org.springframework.data.repository.CrudRepository;

// 제네릭 에 관리 대상 entity 를 넣어줘야함
public interface ArticleRepository extends CrudRepository<Article, Long>
{

}
