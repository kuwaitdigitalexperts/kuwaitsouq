<!DOCTYPE html>
<html lang="{{ $currentLocale ?? 'ar' }}" dir="{{ ($isRtl ?? true) ? 'rtl' : 'ltr' }}" class="h-full bg-slate-100">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>{{ config('app.name', 'KuwaitSouq') }} - @yield('title', 'Marketplace')</title>
    <link rel="icon" type="image/x-icon" href="{{ asset('favicon.ico') }}">
    <link rel="icon" type="image/png" href="{{ asset('images/favicon.png') }}">
    <link rel="apple-touch-icon" href="{{ asset('images/logo_square.png') }}">

    <!-- Google Fonts (Cairo & Inter) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cairo:wght@400;500;600;700;800;900&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <!-- Tailwind CSS (Play CDN) -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        brand: {
                            50: '#eff6ff',
                            100: '#dbeafe',
                            500: '#3b82f6',
                            600: '#1d4ed8',
                            700: '#1e40af',
                            primary: '#1d63ed',
                            secondary: '#0f4dc4',
                        },
                        accent: {
                            orange: '#F59E0B',
                            red: '#E11D48',
                        }
                    },
                    fontFamily: {
                        sans: ['Cairo', 'Inter', 'system-ui', 'sans-serif'],
                    }
                }
            }
        }
    </script>

    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>
        body {
            font-family: 'Cairo', 'Inter', sans-serif;
            -webkit-tap-highlight-color: transparent;
        }
        .hide-scrollbar::-webkit-scrollbar {
            display: none;
        }
        .hide-scrollbar {
            -ms-overflow-style: none;
            scrollbar-width: none;
        }
    </style>
    @stack('styles')
</head>
<body class="min-h-full bg-slate-100 text-slate-800 antialiased flex flex-col selection:bg-blue-500 selection:text-white">

    <!-- Top Universal Bar: Country, Language & Demo Role Switcher -->
    <header class="bg-slate-900 text-white text-xs py-1.5 px-4 sticky top-0 z-50 shadow-md">
        <div class="max-w-7xl mx-auto flex flex-wrap items-center justify-between gap-2">
            <!-- Active Country & Language -->
            <div class="flex items-center gap-3">
                <button type="button" onclick="openCountryModal()" class="flex items-center gap-1.5 bg-slate-800 hover:bg-slate-700 px-2.5 py-1 rounded-md transition font-medium text-amber-400">
                    <span>{{ $currentCountry->flag ?? '🇰🇼' }}</span>
                    <span>{{ $currentCountry->display_name ?? 'Kuwait' }} ({{ $currentCountry->display_currency ?? 'KWD' }})</span>
                    <i class="fa-solid fa-chevron-down text-[10px] opacity-70"></i>
                </button>

                <div class="flex items-center gap-1 bg-slate-800 px-2 py-0.5 rounded text-[11px]">
                    <a href="{{ route('lang.switch', 'ar') }}" class="{{ ($currentLocale ?? 'ar') === 'ar' ? 'text-blue-400 font-bold' : 'text-slate-400' }}">عربي</a>
                    <span class="text-slate-600">|</span>
                    <a href="{{ route('lang.switch', 'en') }}" class="{{ ($currentLocale ?? 'ar') === 'en' ? 'text-blue-400 font-bold' : 'text-slate-400' }}">EN</a>
                </div>
            </div>

            <!-- Role / Quick Demo Switcher -->
            <div class="flex items-center gap-2">
                <span class="text-slate-400 hidden sm:inline">Role:</span>
                <span class="px-2 py-0.5 rounded font-semibold text-[11px] {{ auth()->check() ? (auth()->user()->is_admin ? 'bg-purple-900 text-purple-200' : 'bg-emerald-900 text-emerald-200') : 'bg-slate-800 text-slate-300' }}">
                    @if(auth()->check())
                        {{ auth()->user()->name }}
                    @else
                        Guest
                    @endif
                </span>

                <div class="flex items-center gap-1 text-[11px]">
                    <a href="{{ route('demo.login', 'guest') }}" class="px-1.5 py-0.5 rounded bg-slate-800 hover:bg-slate-700 text-slate-300">Guest</a>
                    <a href="{{ route('demo.login', 'alghanim') }}" class="px-1.5 py-0.5 rounded bg-amber-950 hover:bg-amber-900 text-amber-300 font-medium">Al Ghanim</a>
                    <a href="{{ route('demo.login', 'admin') }}" class="px-1.5 py-0.5 rounded bg-blue-950 hover:bg-blue-900 text-blue-300 font-medium">Admin</a>
                    @if(auth()->check() && auth()->user()->is_admin)
                        <a href="{{ route('admin.dashboard') }}" class="px-2 py-0.5 rounded bg-red-600 hover:bg-red-500 text-white font-bold">Admin Panel</a>
                    @endif
                </div>
            </div>
        </div>
    </header>

    <!-- Desktop Navigation Bar (Visible on md+ screens) -->
    <div class="hidden md:block bg-white border-b border-slate-200 sticky top-7 z-40 shadow-xs">
        <div class="max-w-7xl mx-auto px-4 py-3 flex items-center justify-between gap-6">
            <!-- Brand Logo -->
            <a href="{{ route('home') }}" class="flex items-center gap-3 flex-shrink-0 group">
                <img src="{{ asset('images/logo_icon.svg') }}" alt="KuwaitSouq Logo" class="w-10 h-10 rounded-xl shadow-xs group-hover:scale-105 transition">
                <div>
                    <span class="text-xl font-black text-slate-900 tracking-tight block leading-tight">Kuwait<span class="text-blue-600">Souq</span></span>
                    <span class="text-[10px] text-emerald-600 font-bold block">سوق الكويت والخليج</span>
                </div>
            </a>

            <!-- Search Bar in Desktop Header -->
            <form action="{{ route('home') }}" method="GET" class="flex-1 max-w-2xl relative">
                <div class="relative flex items-center">
                    <i class="fa-solid fa-magnifying-glass absolute {{ ($isRtl ?? true) ? 'right-4' : 'left-4' }} text-slate-400 text-sm"></i>
                    <input type="text" name="q" value="{{ request('q') }}" placeholder="{{ ($isRtl ?? true) ? 'ابحث عن سيارات، عقارات، إلكترونيات، أو أي شيء في ' . ($currentCountry->display_name ?? 'الخليج') : 'Search cars, real estate, electronics in ' . ($currentCountry->display_name ?? 'Gulf') }}"
                        class="w-full bg-slate-50 text-slate-800 {{ ($isRtl ?? true) ? 'pr-11 pl-4' : 'pl-11 pr-4' }} py-2.5 rounded-xl text-sm border border-slate-200 focus:outline-none focus:ring-2 focus:ring-blue-500 shadow-inner">
                    <button type="submit" class="absolute {{ ($isRtl ?? true) ? 'left-1.5' : 'right-1.5' }} bg-blue-600 hover:bg-blue-700 text-white px-4 py-1.5 rounded-lg text-xs font-bold transition">
                        {{ ($isRtl ?? true) ? 'بحث' : 'Search' }}
                    </button>
                </div>
            </form>

            <!-- Desktop Action Buttons -->
            <div class="flex items-center gap-3 flex-shrink-0">
                <!-- Chats -->
                <a href="{{ route('chats') }}" class="flex items-center gap-1.5 text-slate-700 hover:text-blue-600 p-2 rounded-xl hover:bg-slate-50 transition relative" title="Chats">
                    <i class="fa-solid fa-comment-dots text-lg"></i>
                    <span class="text-xs font-bold hidden lg:inline">{{ ($isRtl ?? true) ? 'المحادثات' : 'Chats' }}</span>
                    <span class="absolute top-1 {{ ($isRtl ?? true) ? 'right-1' : 'left-1' }} bg-red-500 text-white text-[9px] font-bold rounded-full w-4 h-4 flex items-center justify-center">14</span>
                </a>

                <!-- Listings -->
                <a href="{{ route('listings') }}" class="flex items-center gap-1.5 text-slate-700 hover:text-blue-600 p-2 rounded-xl hover:bg-slate-50 transition" title="My Listings">
                    <i class="fa-solid fa-newspaper text-lg"></i>
                    <span class="text-xs font-bold hidden lg:inline">{{ ($isRtl ?? true) ? 'إعلاناتي' : 'Listings' }}</span>
                </a>

                <!-- Account -->
                <a href="{{ route('account') }}" class="flex items-center gap-1.5 text-slate-700 hover:text-blue-600 p-2 rounded-xl hover:bg-slate-50 transition" title="Account">
                    <i class="fa-solid fa-user text-lg"></i>
                    <span class="text-xs font-bold hidden lg:inline">{{ ($isRtl ?? true) ? 'حسابي' : 'Account' }}</span>
                </a>

                <!-- Post Ad CTA Button -->
                <a href="{{ route('ads.create') }}" class="bg-gradient-to-r from-amber-500 to-amber-600 hover:from-amber-600 hover:to-amber-700 text-white font-extrabold px-4 py-2.5 rounded-xl text-xs flex items-center gap-2 shadow-md transition transform hover:scale-102">
                    <i class="fa-solid fa-camera"></i>
                    <span>{{ ($isRtl ?? true) ? 'أضف إعلانك مجاناً' : '+ Post Your Ad' }}</span>
                </a>
            </div>
        </div>
    </div>

    <!-- Main Content Container (Full Width Responsive) -->
    <main class="flex-1 w-full max-w-7xl mx-auto px-0 sm:px-4 lg:px-8 py-0 sm:py-6 pb-24 md:pb-12">
        @if(session('success'))
            <div class="m-3 p-3.5 bg-emerald-50 border border-emerald-200 text-emerald-800 text-sm rounded-xl flex items-center justify-between shadow-sm">
                <div class="flex items-center gap-2">
                    <i class="fa-solid fa-circle-check text-emerald-600"></i>
                    <span>{{ session('success') }}</span>
                </div>
                <button type="button" onclick="this.parentElement.remove()" class="text-emerald-500 hover:text-emerald-800">&times;</button>
            </div>
        @endif

        @if(session('info'))
            <div class="m-3 p-3.5 bg-blue-50 border border-blue-200 text-blue-800 text-sm rounded-xl flex items-center justify-between shadow-sm">
                <div class="flex items-center gap-2">
                    <i class="fa-solid fa-circle-info text-blue-600"></i>
                    <span>{{ session('info') }}</span>
                </div>
                <button type="button" onclick="this.parentElement.remove()" class="text-blue-500 hover:text-blue-800">&times;</button>
            </div>
        @endif

        @yield('content')
    </main>

    <!-- Desktop Footer (Hidden on mobile) -->
    <footer class="hidden md:block bg-white border-t border-slate-200 py-10 mt-auto">
        <div class="max-w-7xl mx-auto px-4 grid grid-cols-1 md:grid-cols-4 gap-8 text-xs text-slate-600">
            <div>
                <div class="flex items-center gap-2.5 mb-3">
                    <img src="{{ asset('images/logo_icon.svg') }}" alt="KuwaitSouq Logo" class="w-8 h-8 rounded-lg shadow-xs">
                    <div>
                        <span class="text-lg font-black text-slate-900 block leading-tight">Kuwait<span class="text-blue-600">Souq</span></span>
                        <span class="text-[9.5px] text-emerald-600 font-bold block">سوق الكويت والخليج</span>
                    </div>
                </div>
                <p class="text-slate-500 leading-relaxed mb-3">
                    {{ ($isRtl ?? true) ? 'المنصة الرائدة للإعلانات المبوبة في الكويت ودول الخليج العربي. بيع واشترِ السيارات، العقارات، الإلكترونيات والمزيد.' : 'Leading classifieds platform for Kuwait and GCC countries. Buy and sell autos, property, electronics, and more.' }}
                </p>
                <div class="text-[11px] text-slate-400">© {{ date('Y') }} KuwaitSouq. All rights reserved.</div>
            </div>

            <div>
                <h4 class="font-extrabold text-slate-900 text-sm mb-3">{{ ($isRtl ?? true) ? 'دول الخليج' : 'Gulf Countries' }}</h4>
                <ul class="space-y-2">
                    @foreach($allCountries as $c)
                        <li>
                            <a href="{{ route('country.switch', $c->id) }}" class="hover:text-blue-600 flex items-center gap-2">
                                <span>{{ $c->flag }}</span>
                                <span>{{ $c->display_name }}</span>
                            </a>
                        </li>
                    @endforeach
                </ul>
            </div>

            <div>
                <h4 class="font-extrabold text-slate-900 text-sm mb-3">{{ ($isRtl ?? true) ? 'روابط سريعة' : 'Quick Links' }}</h4>
                <ul class="space-y-2">
                    <li><a href="{{ route('home') }}" class="hover:text-blue-600">{{ ($isRtl ?? true) ? 'الرئيسية' : 'Home' }}</a></li>
                    <li><a href="{{ route('category.show', 'autos') }}" class="hover:text-blue-600">{{ ($isRtl ?? true) ? 'سيارات ومركبات' : 'Autos' }}</a></li>
                    <li><a href="{{ route('category.show', 'real-estate') }}" class="hover:text-blue-600">{{ ($isRtl ?? true) ? 'عقارات' : 'Real Estate' }}</a></li>
                    <li><a href="{{ route('ads.create') }}" class="hover:text-blue-600">{{ ($isRtl ?? true) ? 'أضف إعلانك' : 'Post Ad' }}</a></li>
                    <li><a href="{{ route('account') }}" class="hover:text-blue-600">{{ ($isRtl ?? true) ? 'حسابي' : 'Account' }}</a></li>
                </ul>
            </div>

            <div>
                <h4 class="font-extrabold text-slate-900 text-sm mb-3">{{ ($isRtl ?? true) ? 'المساعدة والدعم' : 'Support & Safety' }}</h4>
                <p class="text-slate-500 mb-2">{{ ($isRtl ?? true) ? 'فريق خدمة العملاء متواجد لمساعدتكم 24/7' : 'Our team is ready to help 24/7' }}</p>
                <div class="font-bold text-blue-600 text-sm mb-2"><i class="fa-solid fa-phone mr-1"></i> +965 99001122</div>
                <div class="text-slate-500">support@kuwaitsouq.com</div>
            </div>
        </div>
    </footer>

    <!-- Mobile Bottom Navigation (Visible ONLY on mobile devices < md) -->
    <nav class="md:hidden fixed bottom-0 left-0 right-0 bg-white border-t border-slate-200 z-40 px-3 py-1.5 shadow-[0_-4px_10px_rgba(0,0,0,0.05)]">
        <div class="max-w-md mx-auto flex items-center justify-between relative">
            <!-- Tab 1: Home -->
            <a href="{{ route('home') }}" class="flex flex-col items-center justify-center flex-1 py-1 {{ request()->routeIs('home') || request()->routeIs('category.show') ? 'text-blue-600 font-bold' : 'text-slate-600' }}">
                <i class="fa-solid fa-house text-lg"></i>
                <span class="text-[11px] font-medium mt-1">{{ ($isRtl ?? true) ? 'الرئيسية' : 'Home' }}</span>
            </a>

            <!-- Tab 2: Chats -->
            <a href="{{ route('chats') }}" class="flex flex-col items-center justify-center flex-1 py-1 relative {{ request()->routeIs('chats*') ? 'text-blue-600 font-bold' : 'text-slate-600' }}">
                <div class="relative">
                    <i class="fa-solid fa-comment-dots text-lg"></i>
                    <span class="absolute -top-1.5 -right-2 bg-red-500 text-white text-[10px] font-bold rounded-full w-4 h-4 flex items-center justify-center">14</span>
                </div>
                <span class="text-[11px] font-medium mt-1">{{ ($isRtl ?? true) ? 'المحادثات' : 'Chats' }}</span>
            </a>

            <!-- Tab 3: Center Floating Add Listing Button -->
            <div class="flex flex-col items-center justify-center flex-1 -mt-6">
                <a href="{{ route('ads.create') }}" class="w-14 h-14 rounded-full bg-gradient-to-tr from-amber-500 to-amber-400 text-white flex items-center justify-center shadow-lg border-4 border-white hover:scale-105 transition-transform active:scale-95">
                    <div class="relative flex items-center justify-center">
                        <i class="fa-solid fa-camera text-xl"></i>
                        <i class="fa-solid fa-plus text-[10px] absolute -top-1 -right-1 bg-white text-amber-500 rounded-full p-0.5"></i>
                    </div>
                </a>
                <span class="text-[10px] font-bold text-slate-800 mt-0.5">{{ ($isRtl ?? true) ? 'أضف إعلان' : 'Add Listing' }}</span>
            </div>

            <!-- Tab 4: Listings -->
            <a href="{{ route('listings') }}" class="flex flex-col items-center justify-center flex-1 py-1 {{ request()->routeIs('listings*') ? 'text-blue-600 font-bold' : 'text-slate-600' }}">
                <i class="fa-solid fa-newspaper text-lg"></i>
                <span class="text-[11px] font-medium mt-1">{{ ($isRtl ?? true) ? 'إعلاناتي' : 'Listings' }}</span>
            </a>

            <!-- Tab 5: Account -->
            <a href="{{ route('account') }}" class="flex flex-col items-center justify-center flex-1 py-1 {{ request()->routeIs('account*') ? 'text-blue-600 font-bold' : 'text-slate-600' }}">
                <i class="fa-solid fa-user text-lg"></i>
                <span class="text-[11px] font-medium mt-1">{{ ($isRtl ?? true) ? 'حسابي' : 'Account' }}</span>
            </a>
        </div>
    </nav>

    <!-- Country Selector Modal -->
    <div id="countryModal" class="fixed inset-0 bg-black/60 z-50 flex items-center justify-center p-4 hidden backdrop-blur-sm">
        <div class="bg-white rounded-2xl max-w-sm w-full p-5 shadow-2xl animate-scale-up">
            <div class="flex items-center justify-between pb-3 border-b border-slate-100 mb-4">
                <h3 class="font-bold text-slate-900 text-base flex items-center gap-2">
                    <i class="fa-solid fa-globe text-blue-600"></i>
                    <span>{{ ($isRtl ?? true) ? 'اختر الدولة (دول الخليج)' : 'Select Country (Gulf)' }}</span>
                </h3>
                <button type="button" onclick="closeCountryModal()" class="text-slate-400 hover:text-slate-600 text-lg">
                    <i class="fa-solid fa-xmark"></i>
                </button>
            </div>

            <div class="space-y-2">
                @foreach($allCountries as $country)
                    <a href="{{ route('country.switch', $country->id) }}" class="flex items-center justify-between p-3 rounded-xl border {{ ($currentCountry->id ?? null) === $country->id ? 'border-blue-600 bg-blue-50 text-blue-900 font-bold' : 'border-slate-100 hover:bg-slate-50 text-slate-800' }} transition">
                        <div class="flex items-center gap-3">
                            <span class="text-2xl">{{ $country->flag }}</span>
                            <div class="text-start">
                                <div class="text-sm font-semibold">{{ $country->display_name }}</div>
                                <div class="text-[11px] text-slate-400">{{ $country->code }} • {{ $country->phone_code }}</div>
                            </div>
                        </div>
                        <div class="text-xs px-2 py-1 bg-white rounded-lg border border-slate-200 font-medium">
                            {{ $country->display_currency }}
                        </div>
                    </a>
                @endforeach
            </div>
        </div>
    </div>

    <script>
        function openCountryModal() {
            document.getElementById('countryModal').classList.remove('hidden');
        }
        function closeCountryModal() {
            document.getElementById('countryModal').classList.add('hidden');
        }
        document.getElementById('countryModal').addEventListener('click', function(e) {
            if (e.target === this) closeCountryModal();
        });
    </script>
    @stack('scripts')
</body>
</html>
