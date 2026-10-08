@extends('layouts.app')

@section('title', ($isRtl ?? true) ? 'تسجيل الدخول' : 'Login')

@section('content')
<div class="p-4 flex-1 flex flex-col justify-center max-w-sm mx-auto w-full">
    <!-- Brand Title -->
    <div class="text-center mb-6 flex flex-col items-center">
        <a href="{{ route('home') }}" class="inline-block mb-2 group">
            <img src="{{ asset('images/logo_icon.svg') }}" alt="KuwaitSouq" class="w-16 h-16 rounded-2xl mx-auto shadow-md group-hover:scale-105 transition">
        </a>
        <h1 class="text-2xl font-black text-slate-900">Kuwait<span class="text-blue-600">Souq</span></h1>
        <p class="text-xs text-emerald-600 font-bold mt-0.5">سوق الكويت والخليج</p>
        <p class="text-[11px] text-slate-400 mt-1">{{ ($isRtl ?? true) ? 'أهلاً بك في منصة الإعلانات الأولى' : 'Welcome to Gulf marketplace' }}</p>
    </div>

    @if($errors->any())
        <div class="mb-4 p-3 bg-rose-50 border border-rose-200 text-rose-800 text-xs rounded-xl">
            {{ $errors->first() }}
        </div>
    @endif

    <!-- Standard Login Form -->
    <form action="{{ route('login.post') }}" method="POST" class="bg-white p-5 rounded-2xl border border-slate-200/90 shadow-sm space-y-3.5 mb-4">
        @csrf

        <div>
            <label class="block text-xs font-bold text-slate-700 mb-1">{{ ($isRtl ?? true) ? 'رقم الهاتف أو البريد الإلكتروني' : 'Phone or Email' }}</label>
            <input type="text" name="login_id" value="{{ old('login_id', '0504880922') }}" required placeholder="0504880922"
                class="w-full bg-slate-50 border border-slate-200 rounded-xl py-2.5 px-3 text-xs font-medium text-slate-800 focus:outline-none focus:ring-2 focus:ring-blue-400">
        </div>

        <div>
            <label class="block text-xs font-bold text-slate-700 mb-1">{{ ($isRtl ?? true) ? 'كلمة المرور' : 'Password' }}</label>
            <input type="password" name="password" value="password123" required placeholder="••••••••"
                class="w-full bg-slate-50 border border-slate-200 rounded-xl py-2.5 px-3 text-xs font-medium text-slate-800 focus:outline-none focus:ring-2 focus:ring-blue-400">
        </div>

        <button type="submit" class="w-full bg-blue-600 hover:bg-blue-700 text-white font-extrabold py-3 rounded-xl text-xs shadow-md transition active:scale-98">
            {{ ($isRtl ?? true) ? 'تسجيل الدخول' : 'Sign In' }}
        </button>
    </form>

    <!-- 1-Click Instant Demo Login Switcher (resolves phone barrier!) -->
    <div class="bg-slate-50 border border-slate-200 rounded-2xl p-4 text-center">
        <h3 class="text-xs font-bold text-slate-800 mb-1">{{ ($isRtl ?? true) ? 'دخول سريع تجريبي بنقرة واحدة' : 'Instant 1-Click Demo Login' }}</h3>
        <p class="text-[11px] text-slate-500 mb-3">{{ ($isRtl ?? true) ? 'جرّب المنصة مباشرة دون الحاجة لأي رمز تحقق SMS' : 'Try the platform without SMS OTP barrier' }}</p>

        <div class="space-y-2">
            <a href="{{ route('demo.login', 'alghanim') }}" class="w-full bg-white hover:bg-amber-50 border border-amber-300 text-amber-900 font-bold py-2 px-3 rounded-xl text-xs flex items-center justify-between transition shadow-2xs">
                <span>⭐ {{ ($isRtl ?? true) ? 'حساب بائع موثق: الغانم العالمية' : 'Verified Seller: Al Ghanim global' }}</span>
                <span class="text-[10px] text-blue-600 font-bold">&rarr;</span>
            </a>

            <a href="{{ route('demo.login', 'fahad') }}" class="w-full bg-white hover:bg-slate-100 border border-slate-200 text-slate-800 font-bold py-2 px-3 rounded-xl text-xs flex items-center justify-between transition shadow-2xs">
                <span>👤 {{ ($isRtl ?? true) ? 'مستخدم قياسي: أبو فهد' : 'User: Abu Fahad' }}</span>
                <span class="text-[10px] text-blue-600 font-bold">&rarr;</span>
            </a>

            <a href="{{ route('demo.login', 'admin') }}" class="w-full bg-white hover:bg-blue-50 border border-blue-300 text-blue-900 font-bold py-2 px-3 rounded-xl text-xs flex items-center justify-between transition shadow-2xs">
                <span>🛡️ {{ ($isRtl ?? true) ? 'لوحة تحكم المسؤول (الأدمن)' : 'KuwaitSouq Admin' }}</span>
                <span class="text-[10px] text-blue-600 font-bold">&rarr;</span>
            </a>
        </div>
    </div>

    <!-- Register Link -->
    <div class="text-center mt-4 text-xs text-slate-600">
        <span>{{ ($isRtl ?? true) ? 'ليس لديك حساب؟' : "Don't have an account?" }}</span>
        <a href="{{ route('register') }}" class="font-bold text-blue-600 hover:underline">
            {{ ($isRtl ?? true) ? 'سجل الآن مجاناً' : 'Register Free' }}
        </a>
    </div>
</div>
@endsection
