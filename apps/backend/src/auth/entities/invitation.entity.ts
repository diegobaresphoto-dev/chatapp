import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('invitations')
export class Invitation {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column({ unique: true })
    code: string;

    @Column({ default: 1 })
    maxUses: number;

    @Column({ default: 0 })
    uses: number;

    @Column({ type: 'timestamp', nullable: true })
    expiresAt: Date;

    @CreateDateColumn()
    createdAt: Date;

    @Column({ nullable: true })
    createdBy: string;
}
