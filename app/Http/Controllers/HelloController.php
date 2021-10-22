<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;

class HelloController extends Controller
{
    public function hello(Request $request) {
        $name = $request->get('name');
        if (Cache::get('user_name') == $name) {
            return 'Redis 检查， ' . $name . ' 已被找到';
        }
        $user = User::query()
            ->where('name', $name)
            ->first();
        if ($user) {
            Cache::put('user_name', $name, 60);
            return $name . ' 已被找到';
        }
        return $name . ' 未找到';
    }

    public function say(Request $request)
    {
        $name = $request->get('name');
        if (Cache::get('user_name') == $name) {
            return 'Redis 检查， ' . $name . ' 已被创建';
        }
        $user = User::query()
            ->firstOrCreate([
                'name' => 'fdsfdsf',
            ]);
        Cache::put('user_name', $name, 60);
        return $name . ' 创建完成';
    }
}
