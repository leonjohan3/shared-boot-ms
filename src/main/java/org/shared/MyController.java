package org.shared;

import lombok.NoArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@NoArgsConstructor
class MyController {

    @GetMapping("/hello")
    MyResponse sayHello() {
        return new MyResponse("hello from shared ws");
    }
}
