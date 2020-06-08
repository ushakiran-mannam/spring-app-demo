package com.example.demo.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequestMapping("/")
@RestController
public class Hello {

    @GetMapping("/")
    public String Testfunc() {
        return "sample spring boot java application ";
    }

}