import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne } from 'typeorm';
import { User } from '../../auth/entities/user.entity';

@Entity('messages')
export class Message {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column()
    conversationId: string;

    @ManyToOne(() => User)
    sender: User;

    @Column()
    senderDeviceId: number;

    @Column({ type: 'text' })
    ciphertext: string; // Base64 encoded Signal message

    @CreateDateColumn()
    createdAt: Date;

    @Column({ type: 'timestamp', nullable: true })
    editedAt: Date;

    @Column({ type: 'timestamp', nullable: true })
    deletedAt: Date;
}
