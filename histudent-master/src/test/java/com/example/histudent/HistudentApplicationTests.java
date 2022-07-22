package com.example.histudent;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.example.histudent.mapper.UserMapper;
import com.example.histudent.pojo.User;
import com.example.histudent.service.UserService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class HistudentApplicationTests {

	@Autowired
	UserService userService;

	@Autowired
	UserMapper userMapper;

	@Test
	void contextLoads() {
	}

	@Test
	void test01(){

	}

	@Test
	void test02(){

	}
}
