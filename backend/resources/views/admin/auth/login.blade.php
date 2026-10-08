<!DOCTYPE html>
<html lang="en" class="h-full bg-slate-950">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>KuwaitSouq - Admin Authentication</title>
    <link rel="icon" type="image/x-icon" href="{{ asset('favicon.ico') }}">
    <link rel="icon" type="image/png" href="{{ asset('images/favicon.png') }}">
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
</head>
<body class="h-full font-['Inter',sans-serif] text-slate-100 flex items-center justify-center p-4">

    <div class="max-w-sm w-full bg-slate-900 border border-slate-800 rounded-3xl p-6 shadow-2xl">
        <div class="text-center mb-6">
            <img src="{{ asset('images/logo_icon.svg') }}" alt="KuwaitSouq Logo" class="w-14 h-14 rounded-2xl mx-auto mb-3 shadow-lg">
            <h1 class="text-lg font-black text-white">Kuwait<span class="text-blue-400">Souq</span> Control Center</h1>
            <p class="text-xs text-slate-400 mt-1">Sign in with administrator credentials</p>
        </div>

        @if($errors->any())
            <div class="mb-4 p-3 bg-rose-950 border border-rose-800 text-rose-200 text-xs rounded-xl">
                {{ $errors->first() }}
            </div>
        @endif

        <form action="{{ route('admin.login.post') }}" method="POST" class="space-y-4 text-xs">
            @csrf
            <div>
                <label class="block text-slate-400 font-bold mb-1">Email</label>
                <input type="email" name="email" value="{{ old('email', 'admin@kuwaitsouq.com') }}" required class="w-full bg-slate-950 border border-slate-800 rounded-xl p-3 text-white focus:outline-none focus:border-blue-500">
            </div>

            <div>
                <label class="block text-slate-400 font-bold mb-1">Password</label>
                <input type="password" name="password" value="password123" required class="w-full bg-slate-950 border border-slate-800 rounded-xl p-3 text-white focus:outline-none focus:border-blue-500">
            </div>

            <button type="submit" class="w-full bg-blue-600 hover:bg-blue-500 text-white font-black py-3 rounded-xl transition shadow-lg">
                Sign In to Dashboard
            </button>
        </form>

        <div class="mt-6 pt-4 border-t border-slate-800 text-center">
            <a href="{{ route('home') }}" class="text-xs text-slate-400 hover:text-white">&larr; Back to Public Portal</a>
        </div>
    </div>

</body>
</html>
