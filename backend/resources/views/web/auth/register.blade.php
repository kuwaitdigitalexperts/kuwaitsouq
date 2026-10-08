@extends('layouts.app')

@section('title', ($isRtl ?? true) ? 'إنشاء حساب جديد' : 'Register')

@section('content')
<div class="p-4 flex-1 flex flex-col justify-center max-w-sm mx-auto w-full">
    <div class="text-center mb-5 flex flex-col items-center">
        <a href="{{ route('home') }}" class="inline-block mb-2 group">
            <img src="{{ asset('images/logo_icon.svg') }}" alt="KuwaitSouq" class="w-16 h-16 rounded-2xl mx-auto shadow-md group-hover:scale-105 transition">
        </a>
        <h1 class="text-2xl font-black text-slate-900">Kuwait<span class="text-blue-600">Souq</span></h1>
        <p class="text-xs text-emerald-600 font-bold mt-0.5">سوق الكويت والخليج</p>
        <p class="text-[11px] text-slate-400 mt-1">{{ ($isRtl ?? true) ? 'انضم لآلاف المعلنين في الكويت والخليج' : 'Join thousands of Gulf listers' }}</p>
    </div>

    @if($errors->any())
        <div class="mb-4 p-3 bg-rose-50 border border-rose-200 text-rose-800 text-xs rounded-xl">
            {{ $errors->first() }}
        </div>
    @endif

    <form action="{{ route('register.post') }}" method="POST" class="bg-white p-5 rounded-2xl border border-slate-200/90 shadow-sm space-y-3.5 mb-4">
        @csrf

        <div>
            <label class="block text-xs font-bold text-slate-700 mb-1">{{ ($isRtl ?? true) ? 'الاسم بالكامل / اسم النشاط' : 'Full Name / Business Name' }} *</label>
            <input type="text" name="name" value="{{ old('name') }}" required placeholder="{{ ($isRtl ?? true) ? 'مثال: شركة النور للتجارة' : 'e.g. Al Noor Trading' }}"
                class="w-full bg-slate-50 border border-slate-200 rounded-xl py-2 px-3 text-xs text-slate-800 focus:ring-2 focus:ring-blue-400">
        </div>

        <div>
            <label class="block text-xs font-bold text-slate-700 mb-1">{{ ($isRtl ?? true) ? 'رمز الدولة ورقم الهاتف' : 'Phone Prefix & Number' }} *</label>
            <div class="flex gap-2">
                <select name="phone_code" class="w-32 bg-slate-50 border border-slate-200 rounded-xl py-2 px-2 text-xs font-bold text-slate-800 focus:ring-2 focus:ring-blue-400">
                    <option value="+965">🇰🇼 +965</option>
                    <option value="+966">🇸🇦 +966</option>
                    <option value="+971">🇦🇪 +971</option>
                    <option value="+974">🇶🇦 +974</option>
                    <option value="+973">🇧🇭 +973</option>
                    <option value="+968">🇴🇲 +968</option>
                    <option value="+1">🇺🇸 +1</option>
                    <option value="+44">🇬🇧 +44</option>
                    <option value="+91">🇮🇳 +91</option>
                    <option value="+92">🇵🇰 +92</option>
                    <option value="+880">🇧🇩 +880</option>
                </select>
                <input type="tel" name="phone" value="{{ old('phone') }}" required placeholder="504880922"
                    class="flex-1 bg-slate-50 border border-slate-200 rounded-xl py-2 px-3 text-xs font-bold text-slate-800 focus:ring-2 focus:ring-blue-400">
            </div>
        </div>

        <div>
            <label class="block text-xs font-bold text-slate-700 mb-1">{{ ($isRtl ?? true) ? 'البريد الإلكتروني (اختياري)' : 'Email (Optional)' }}</label>
            <input type="email" name="email" value="{{ old('email') }}" placeholder="user@example.com"
                class="w-full bg-slate-50 border border-slate-200 rounded-xl py-2 px-3 text-xs text-slate-800 focus:ring-2 focus:ring-blue-400">
        </div>

        <div>
            <label class="block text-xs font-bold text-slate-700 mb-1">{{ ($isRtl ?? true) ? 'كلمة المرور' : 'Password' }} *</label>
            <input type="password" name="password" required placeholder="••••••••"
                class="w-full bg-slate-50 border border-slate-200 rounded-xl py-2 px-3 text-xs text-slate-800 focus:ring-2 focus:ring-blue-400">
        </div>

        <div>
            <label class="block text-xs font-bold text-slate-700 mb-1">{{ ($isRtl ?? true) ? 'تأكيد كلمة المرور' : 'Confirm Password' }} *</label>
            <input type="password" name="password_confirmation" required placeholder="••••••••"
                class="w-full bg-slate-50 border border-slate-200 rounded-xl py-2 px-3 text-xs text-slate-800 focus:ring-2 focus:ring-blue-400">
        </div>

        <button type="submit" class="w-full bg-blue-600 hover:bg-blue-700 text-white font-extrabold py-3 rounded-xl text-xs shadow-md transition active:scale-98">
            {{ ($isRtl ?? true) ? 'إنشاء الحساب' : 'Create Account' }}
        </button>
    </form>

    <div class="text-center text-xs text-slate-600">
        <span>{{ ($isRtl ?? true) ? 'لديك حساب بالفعل؟' : 'Already have an account?' }}</span>
        <a href="{{ route('login') }}" class="font-bold text-blue-600 hover:underline">
            {{ ($isRtl ?? true) ? 'تسجيل الدخول' : 'Sign In' }}
        </a>
    </div>
</div>
@endsection
