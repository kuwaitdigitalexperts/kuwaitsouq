<!DOCTYPE html>
<html lang="en" class="h-full bg-slate-900">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>KuwaitSouq Admin - @yield('title', 'Control Center')</title>
    <link rel="icon" type="image/x-icon" href="{{ asset('favicon.ico') }}">
    <link rel="icon" type="image/png" href="{{ asset('images/favicon.png') }}">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body class="h-full font-['Inter',sans-serif] text-slate-100 antialiased flex">

    <!-- Admin Sidebar -->
    <aside class="w-64 bg-slate-950 border-r border-slate-800 flex flex-col justify-between p-4 flex-shrink-0">
        <div>
            <!-- Logo & Brand -->
            <div class="flex items-center gap-3 px-2 py-3 mb-6 border-b border-slate-800">
                <img src="{{ asset('images/logo_icon.svg') }}" alt="KuwaitSouq Logo" class="w-9 h-9 rounded-xl shadow">
                <div>
                    <h1 class="font-black text-sm text-white tracking-wide">Kuwait<span class="text-blue-400">Souq</span></h1>
                    <span class="text-[10px] text-emerald-400 font-bold uppercase tracking-wider">Admin Panel</span>
                </div>
            </div>

            <!-- Navigation Links -->
            <nav class="space-y-1 text-xs font-semibold">
                <a href="{{ route('admin.dashboard') }}" class="flex items-center gap-3 px-3 py-2.5 rounded-xl transition {{ request()->routeIs('admin.dashboard') ? 'bg-blue-600 text-white shadow-sm' : 'text-slate-400 hover:bg-slate-900 hover:text-white' }}">
                    <i class="fa-solid fa-chart-line w-4"></i>
                    <span>Dashboard</span>
                </a>

                <a href="{{ route('admin.countries.index') }}" class="flex items-center gap-3 px-3 py-2.5 rounded-xl transition {{ request()->routeIs('admin.countries*') ? 'bg-blue-600 text-white shadow-sm' : 'text-slate-400 hover:bg-slate-900 hover:text-white' }}">
                    <i class="fa-solid fa-earth-americas w-4"></i>
                    <span>Gulf Countries</span>
                </a>

                <a href="{{ route('admin.cities.index') }}" class="flex items-center gap-3 px-3 py-2.5 rounded-xl transition {{ request()->routeIs('admin.cities*') ? 'bg-blue-600 text-white shadow-sm' : 'text-slate-400 hover:bg-slate-900 hover:text-white' }}">
                    <i class="fa-solid fa-city w-4"></i>
                    <span>Cities & Areas</span>
                </a>

                <a href="{{ route('admin.categories.index') }}" class="flex items-center gap-3 px-3 py-2.5 rounded-xl transition {{ request()->routeIs('admin.categories*') ? 'bg-blue-600 text-white shadow-sm' : 'text-slate-400 hover:bg-slate-900 hover:text-white' }}">
                    <i class="fa-solid fa-shapes w-4"></i>
                    <span>Categories & Subs</span>
                </a>

                <a href="{{ route('admin.filters.index') }}" class="flex items-center gap-3 px-3 py-2.5 rounded-xl transition {{ request()->routeIs('admin.filters*') ? 'bg-blue-600 text-white shadow-sm' : 'text-slate-400 hover:bg-slate-900 hover:text-white' }}">
                    <i class="fa-solid fa-sliders w-4"></i>
                    <span>Dynamic Filters & Brands</span>
                </a>

                <a href="{{ route('admin.ads.index') }}" class="flex items-center gap-3 px-3 py-2.5 rounded-xl transition {{ request()->routeIs('admin.ads*') ? 'bg-blue-600 text-white shadow-sm' : 'text-slate-400 hover:bg-slate-900 hover:text-white' }}">
                    <i class="fa-solid fa-newspaper w-4"></i>
                    <span>Ads & Rocket Boost</span>
                </a>

                <a href="{{ route('admin.users.index') }}" class="flex items-center gap-3 px-3 py-2.5 rounded-xl transition {{ request()->routeIs('admin.users*') ? 'bg-blue-600 text-white shadow-sm' : 'text-slate-400 hover:bg-slate-900 hover:text-white' }}">
                    <i class="fa-solid fa-users-gear w-4"></i>
                    <span>Users & Sellers</span>
                </a>
            </nav>
        </div>

        <div class="pt-4 border-t border-slate-800 space-y-2 text-xs">
            <a href="{{ route('home') }}" class="flex items-center gap-2 px-3 py-2 rounded-xl text-slate-400 hover:bg-slate-900 hover:text-white transition">
                <i class="fa-solid fa-arrow-up-right-from-square text-xs"></i>
                <span>Open Public Portal</span>
            </a>

            <form action="{{ route('admin.logout') }}" method="POST">
                @csrf
                <button type="submit" class="w-full flex items-center gap-2 px-3 py-2 rounded-xl text-rose-400 hover:bg-rose-950/40 transition">
                    <i class="fa-solid fa-right-from-bracket text-xs"></i>
                    <span>Log Out</span>
                </button>
            </form>
        </div>
    </aside>

    <!-- Main Content Area -->
    <main class="flex-1 overflow-y-auto bg-slate-900 p-6">
        @if(session('success'))
            <div class="mb-5 p-3.5 bg-emerald-950 border border-emerald-700 text-emerald-200 text-xs rounded-xl flex items-center justify-between">
                <span>{{ session('success') }}</span>
                <button type="button" onclick="this.parentElement.remove()" class="text-emerald-400">&times;</button>
            </div>
        @endif

        @if(session('error'))
            <div class="mb-5 p-3.5 bg-rose-950 border border-rose-700 text-rose-200 text-xs rounded-xl flex items-center justify-between">
                <span>{{ session('error') }}</span>
                <button type="button" onclick="this.parentElement.remove()" class="text-rose-400">&times;</button>
            </div>
        @endif

        @yield('content')
    </main>

</body>
</html>
