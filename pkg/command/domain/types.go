package domain

import (
	"cqrs-es-spec-kit-go/pkg/command/domain/events"
	gt "github.com/barweiss/go-tuple"
)

type GroupChatWithEventPair = gt.Pair[GroupChat, events.GroupChatEvent]
