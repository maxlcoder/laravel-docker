<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class HelloController extends Controller
{
    public function hello(Request $request) {
        return 'hello world';
    }

    public function say(Request $request)
    {
        return 'hello';
    }
}
