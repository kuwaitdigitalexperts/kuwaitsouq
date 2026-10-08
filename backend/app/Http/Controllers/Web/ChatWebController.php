<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use App\Models\Message;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ChatWebController extends Controller
{
    public function index()
    {
        $userId = Auth::id() ?? 2; // fallback to demo seller if not logged in

        // Find distinct chat contacts
        $messages = Message::where('sender_id', $userId)
            ->orWhere('receiver_id', $userId)
            ->with(['sender', 'receiver', 'ad'])
            ->latest()
            ->get();

        $contacts = [];
        foreach ($messages as $msg) {
            $otherUser = $msg->sender_id === $userId ? $msg->receiver : $msg->sender;
            if ($otherUser && !isset($contacts[$otherUser->id])) {
                $contacts[$otherUser->id] = [
                    'user' => $otherUser,
                    'last_message' => $msg,
                    'unread_count' => Message::where('sender_id', $otherUser->id)
                        ->where('receiver_id', $userId)
                        ->where('is_read', false)
                        ->count(),
                ];
            }
        }

        // If no contacts yet, create demo thread with Abu Fahad
        if (empty($contacts)) {
            $demoPartner = User::where('id', '!=', $userId)->first();
            if ($demoPartner) {
                $contacts[$demoPartner->id] = [
                    'user' => $demoPartner,
                    'last_message' => (object)[
                        'message' => 'مرحباً، هل السكوتر ما زال متوفر؟',
                        'created_at' => now()->subMinutes(15),
                    ],
                    'unread_count' => 1,
                ];
            }
        }

        return view('web.chats.index', compact('contacts', 'userId'));
    }

    public function show(int $userId)
    {
        $currentUserId = Auth::id() ?? 2;
        $partner = User::findOrFail($userId);

        $messages = Message::where(function ($q) use ($currentUserId, $userId) {
            $q->where('sender_id', $currentUserId)->where('receiver_id', $userId);
        })->orWhere(function ($q) use ($currentUserId, $userId) {
            $q->where('sender_id', $userId)->where('receiver_id', $currentUserId);
        })->with('ad')->orderBy('created_at')->get();

        // Mark as read
        Message::where('sender_id', $userId)->where('receiver_id', $currentUserId)->update(['is_read' => true]);

        return view('web.chats.show', compact('partner', 'messages', 'currentUserId'));
    }

    public function send(Request $request, int $userId)
    {
        $request->validate(['message' => 'required|string']);

        $currentUserId = Auth::id() ?? 2;
        Message::create([
            'sender_id' => $currentUserId,
            'receiver_id' => $userId,
            'message' => $request->message,
            'is_read' => false,
        ]);

        return redirect()->route('chats.show', $userId);
    }
}
