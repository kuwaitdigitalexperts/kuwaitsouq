@extends('layouts.app')

@section('title', ($isRtl ?? true) ? 'المحادثات' : 'Chats')

@section('content')
<!-- Header matching app style -->
<div class="bg-white px-4 pt-4 pb-3 border-b border-slate-100 flex items-center justify-between sticky top-7 z-30 shadow-xs">
    <h1 class="text-xl font-black text-slate-900">
        {{ ($isRtl ?? true) ? 'المحادثات' : 'Chats' }}
    </h1>

    <div class="flex items-center gap-3">
        <button type="button" class="text-slate-700 hover:text-slate-900">
            <i class="fa-solid fa-magnifying-glass text-lg"></i>
        </button>
    </div>
</div>

<div class="p-3">
    <div class="bg-white rounded-2xl border border-slate-200/90 divide-y divide-slate-100 overflow-hidden shadow-xs">
        @forelse($contacts as $partnerId => $c)
            <a href="{{ route('chats.show', $partnerId) }}" class="flex items-center gap-3 p-3.5 hover:bg-slate-50 transition">
                <!-- Avatar -->
                <div class="w-12 h-12 rounded-full bg-slate-100 border border-slate-200 flex items-center justify-center text-slate-600 font-bold text-base flex-shrink-0 relative">
                    <span>{{ mb_substr($c['user']->name ?? 'User', 0, 1) }}</span>
                    @if($c['unread_count'] > 0)
                        <span class="absolute top-0 right-0 w-3.5 h-3.5 bg-blue-600 rounded-full border-2 border-white"></span>
                    @endif
                </div>

                <!-- Content -->
                <div class="flex-1 min-w-0 text-start">
                    <div class="flex items-center justify-between mb-1">
                        <h2 class="text-xs font-bold text-slate-900 truncate">{{ $c['user']->name ?? 'User' }}</h2>
                        <span class="text-[10px] text-slate-400">{{ is_object($c['last_message']->created_at) ? $c['last_message']->created_at->diffForHumans() : '15m ago' }}</span>
                    </div>
                    <p class="text-xs text-slate-500 truncate">{{ $c['last_message']->message }}</p>
                </div>
            </a>
        @empty
            <div class="p-8 text-center text-slate-400 text-xs">
                {{ ($isRtl ?? true) ? 'لا توجد محادثات سابقة' : 'No chats yet' }}
            </div>
        @endforelse
    </div>
</div>
@endsection
